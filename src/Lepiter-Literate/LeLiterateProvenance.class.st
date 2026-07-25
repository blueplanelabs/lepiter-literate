Class {
	#name : 'LeLiterateProvenance',
	#superclass : 'Object',
	#instVars : [
		'histories',
		'interestingPackageNames',
		'sequenceCounter',
		'currentSnippet'
	],
	#classVars : [
		'Default'
	],
	#category : 'Lepiter-Literate-Provenance',
	#package : 'Lepiter-Literate',
	#tag : 'Provenance'
}

{ #category : 'accessing' }
LeLiterateProvenance class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
LeLiterateProvenance class >> resetDefault [
	Default := nil
]

{ #category : 'private' }
LeLiterateProvenance >> actionForKey: aKey announcement: anAnnouncement [
	((anAnnouncement isKindOf: ClassRemoved) or: [ anAnnouncement isKindOf: MethodRemoved ])
		ifTrue: [ ^ #removed ].
	^ (histories includesKey: aKey) ifTrue: [ #modified ] ifFalse: [ #created ]
]

{ #category : 'configuration' }
LeLiterateProvenance >> addInterestingPackageNamed: aPackageName [
	interestingPackageNames add: aPackageName
]

{ #category : 'accessing' }
LeLiterateProvenance >> artifactForKey: aKey [
	"Resuelve una clave a su artefacto vivo: la clase, o el CompiledMethod si aún existe."
	| index classPart selectorPart behavior |
	index := aKey indexOfSubCollection: '>>#'.
	index = 0 ifTrue: [ ^ Smalltalk classNamed: aKey ].
	classPart := aKey copyFrom: 1 to: index - 1.
	selectorPart := (aKey copyFrom: index + 3 to: aKey size) asSymbol.
	behavior := (classPart endsWith: ' class')
		ifTrue: [ (Smalltalk classNamed: (classPart withoutSuffix: ' class')) ifNotNil: [ :aClass | aClass class ] ]
		ifFalse: [ Smalltalk classNamed: classPart ].
	behavior ifNil: [ ^ nil ].
	^ behavior compiledMethodAt: selectorPart ifAbsent: [ behavior ]
]

{ #category : 'accessing' }
LeLiterateProvenance >> artifactKeys [
	^ histories keys
]

{ #category : 'capturing' }
LeLiterateProvenance >> capturingFor: aSnippet during: aBlock [
	currentSnippet := aSnippet.
	SystemAnnouncer uniqueInstance
		when: ClassAdded , ClassModificationApplied , ClassRemoved , MethodAdded , MethodModified , MethodRemoved
		do: [ :anAnnouncement | self recordAnnouncement: anAnnouncement ]
		for: self.
	^ aBlock ensure: [
		SystemAnnouncer uniqueInstance unsubscribe: self.
		currentSnippet := nil ]
]

{ #category : 'accessing' }
LeLiterateProvenance >> entriesForSnippetUidString: aUidString [
	"Índice inverso: todas las asociaciones clave -> entrada producidas por un snippet."
	| result |
	result := OrderedCollection new.
	histories keysAndValuesDo: [ :key :history |
		history entries do: [ :entry |
			entry snippetUid uidString = aUidString ifTrue: [ result add: key -> entry ] ] ].
	^ result asSortedCollection: [ :a :b | a value sequence <= b value sequence ]
]

{ #category : 'accessing' }
LeLiterateProvenance >> entriesRelatedToClassNamed: aClassName [
	"Todas las entradas de la clase, sus métodos de instancia y sus métodos de lado clase,
	como asociaciones clave -> entrada ordenadas por secuencia global."
	| result |
	result := OrderedCollection new.
	histories keysAndValuesDo: [ :key :history |
		(key = aClassName
			or: [ (key beginsWith: aClassName , '>>#')
				or: [ key beginsWith: aClassName , ' class' ] ])
			ifTrue: [ history entries do: [ :entry | result add: key -> entry ] ] ].
	^ result asSortedCollection: [ :a :b | a value sequence <= b value sequence ]
]

{ #category : 'accessing' }
LeLiterateProvenance >> historyForClass: aClass [
	^ self historyForKey: (self keyForClass: aClass)
]

{ #category : 'accessing' }
LeLiterateProvenance >> historyForKey: aKey [
	^ histories at: aKey ifAbsent: [ LeLiterateCodeHistory new ]
]

{ #category : 'accessing' }
LeLiterateProvenance >> historyForMethod: aCompiledMethod [
	^ self historyForKey: (self keyForClass: aCompiledMethod methodClass selector: aCompiledMethod selector)
]

{ #category : 'initialization' }
LeLiterateProvenance >> initialize [
	super initialize.
	histories := Dictionary new.
	interestingPackageNames := Set new.
	sequenceCounter := 0
]

{ #category : 'configuration' }
LeLiterateProvenance >> interestingPackageNames [
	^ interestingPackageNames
]

{ #category : 'configuration' }
LeLiterateProvenance >> isInterestingPackageNamed: aPackageName [
	"Filtro explícito: con el filtro vacío no se registra nada."
	^ aPackageName notNil and: [ interestingPackageNames includes: aPackageName ]
]

{ #category : 'private' }
LeLiterateProvenance >> keyForClass: aClass [
	^ aClass name asString
]

{ #category : 'private' }
LeLiterateProvenance >> keyForClass: aClass selector: aSelector [
	^ aClass name asString , '>>#' , aSelector asString
]

{ #category : 'private' }
LeLiterateProvenance >> nextSequence [
	^ sequenceCounter := sequenceCounter + 1
]

{ #category : 'printing' }
LeLiterateProvenance >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('; print: histories size; nextPutAll: ' artefactos)'
]

{ #category : 'capturing' }
LeLiterateProvenance >> recordAnnouncement: anAnnouncement [
	| affectedClass selector packageName key |
	currentSnippet ifNil: [ ^ self ].
	affectedClass := [ anAnnouncement classAffected ] on: Error do: [ :e | nil ].
	affectedClass ifNil: [ ^ self ].
	selector := [ anAnnouncement methodAffected ifNotNil: [ :aMethod | aMethod selector ] ]
		on: Error do: [ :e | nil ].
	packageName := [ selector
		ifNil: [ affectedClass package name ]
		ifNotNil: [ anAnnouncement methodAffected package name ] ] on: Error do: [ :e | nil ].
	(self isInterestingPackageNamed: packageName) ifFalse: [ ^ self ].
	key := selector
		ifNil: [ self keyForClass: affectedClass ]
		ifNotNil: [ self keyForClass: affectedClass selector: selector ].
	self recordKey: key action: (self actionForKey: key announcement: anAnnouncement)
]

{ #category : 'capturing' }
LeLiterateProvenance >> recordKey: aKey action: anAction [
	| history entry |
	history := histories at: aKey ifAbsentPut: [ LeLiterateCodeHistory new ].
	entry := LeLiterateProvenanceEntry
		forSnippet: currentSnippet
		action: anAction
		sequence: self nextSequence.
	history addEntry: entry
]
