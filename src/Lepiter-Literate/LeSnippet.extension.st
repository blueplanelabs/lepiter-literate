Extension { #name : 'LeSnippet' }

{ #category : '*Lepiter-Literate' }
LeSnippet >> assimilateWith: aKnowledgeAssimilatorClass [
	"Do nothing if snippet type is not knowledge"
	"Implement for knowledge snippet type"
]

{ #category : '*Lepiter-Literate' }
LeSnippet >> gtGeneratedCodeFor: aView [
	<gtView>
	| associations |
	self uid ifNil: [ ^ aView empty ].
	associations := LeLiterateProvenance default entriesForSnippetUidString: self uid uidString.
	associations isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Generated code';
		priority: 60;
		items: [ (LeLiterateProvenance default entriesForSnippetUidString: self uid uidString) asOrderedCollection ];
		column: 'Seq' text: [ :each | each value sequence ] width: 50;
		column: 'Artifact' text: [ :each | each key ];
		column: 'Action' text: [ :each | each value action ];
		send: [ :each | (LeLiterateProvenance default artifactForKey: each key) ifNil: [ each value ] ]
]

{ #category : '*Lepiter-Literate' }
LeSnippet >> isKnowledge [
	^ false
]
