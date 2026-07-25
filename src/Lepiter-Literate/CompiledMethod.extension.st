Extension { #name : 'CompiledMethod' }

{ #category : '*Lepiter-Literate' }
CompiledMethod >> gtLiterateOriginFor: aView [
	<gtView>
	| history |
	history := LeLiterateProvenance default historyForMethod: self.
	history isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Literate origin';
		priority: 60;
		items: [ (LeLiterateProvenance default historyForMethod: self) entries ];
		column: 'Seq' text: [ :each | each sequence ] width: 50;
		column: 'Action' text: [ :each | each action ];
		column: 'Page' text: [ :each | each pageTitle ifNil: [ '' ] ];
		column: 'Applied' text: [ :each | each lastAppliedAt printString ];
		send: [ :each | each resolvedSnippet ifNil: [ each ] ]
]
