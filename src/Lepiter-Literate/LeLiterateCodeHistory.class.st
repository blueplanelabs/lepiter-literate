Class {
	#name : 'LeLiterateCodeHistory',
	#superclass : 'Object',
	#instVars : [
		'entries'
	],
	#category : 'Lepiter-Literate-Provenance',
	#package : 'Lepiter-Literate',
	#tag : 'Provenance'
}

{ #category : 'adding' }
LeLiterateCodeHistory >> addEntry: anEntry [
	"Idempotente por snippet: si ya hay una entrada del mismo snippet, se refresca
	su marca de tiempo conservando la acción y la posición originales."
	| existing |
	existing := entries
		detect: [ :each | each snippetUid uidString = anEntry snippetUid uidString ]
		ifNone: [ nil ].
	existing
		ifNil: [ entries add: anEntry. ^ anEntry ]
		ifNotNil: [ existing lastAppliedAt: anEntry lastAppliedAt. ^ existing ]
]

{ #category : 'accessing' }
LeLiterateCodeHistory >> entries [
	^ entries
]

{ #category : 'initialization' }
LeLiterateCodeHistory >> initialize [
	super initialize.
	entries := OrderedCollection new
]

{ #category : 'testing' }
LeLiterateCodeHistory >> isEmpty [
	^ entries isEmpty
]

{ #category : 'testing' }
LeLiterateCodeHistory >> notEmpty [
	^ entries notEmpty
]

{ #category : 'printing' }
LeLiterateCodeHistory >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('; print: entries size; nextPutAll: ' entradas)'
]

{ #category : 'accessing' }
LeLiterateCodeHistory >> size [
	^ entries size
]
