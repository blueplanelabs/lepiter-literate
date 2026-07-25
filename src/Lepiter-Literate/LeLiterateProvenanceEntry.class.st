Class {
	#name : 'LeLiterateProvenanceEntry',
	#superclass : 'Object',
	#instVars : [
		'snippetUid',
		'pageTitle',
		'databaseName',
		'action',
		'sequence',
		'lastAppliedAt'
	],
	#category : 'Lepiter-Literate-Provenance',
	#package : 'Lepiter-Literate',
	#tag : 'Provenance'
}

{ #category : 'instance creation' }
LeLiterateProvenanceEntry class >> forSnippet: aSnippet action: anAction sequence: aNumber [
	^ self new
		snippetUid: aSnippet uid;
		pageTitle: (aSnippet page ifNotNil: [ :aPage | aPage title ]);
		databaseName: (aSnippet database ifNotNil: [ :aDatabase | aDatabase databaseName ]);
		action: anAction;
		sequence: aNumber;
		lastAppliedAt: DateAndTime now;
		yourself
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> action [
	^ action
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> action: aSymbol [
	action := aSymbol
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> databaseName [
	^ databaseName
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> databaseName: aString [
	databaseName := aString
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> lastAppliedAt [
	^ lastAppliedAt
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> lastAppliedAt: aDateAndTime [
	lastAppliedAt := aDateAndTime
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> pageTitle [
	^ pageTitle
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> pageTitle: aString [
	pageTitle := aString
]

{ #category : 'printing' }
LeLiterateProvenanceEntry >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: self action asString;
		nextPutAll: ' por snippet de la página: ';
		nextPutAll: (self pageTitle ifNil: [ '?' ]);
		nextPutAll: ')'
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> resolvedSnippet [
	"Resuelve perezosamente el snippet vivo por su UID en las bases registradas."
	self snippetUid ifNil: [ ^ nil ].
	LeDatabasesRegistry default currentLoadedDefaultLogicalDatabase databases
		do: [ :aDatabase |
			(aDatabase blockWithUID: self snippetUid ifPresent: [ :aSnippet | aSnippet ] ifAbsent: [ nil ])
				ifNotNil: [ :aSnippet | ^ aSnippet ] ].
	^ nil
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> sequence [
	^ sequence
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> sequence: aNumber [
	sequence := aNumber
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> snippetUid [
	^ snippetUid
]

{ #category : 'accessing' }
LeLiterateProvenanceEntry >> snippetUid: aLeUID [
	snippetUid := aLeUID
]
