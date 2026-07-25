Extension { #name : 'ClassDescription' }

{ #category : '*Lepiter-Literate' }
ClassDescription >> gtLiterateOriginFor: aView [
	<gtView>
	| related |
	related := LeLiterateProvenance default entriesRelatedToClassNamed: self instanceSide name asString.
	related isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Literate origin';
		priority: 60;
		items: [ (LeLiterateProvenance default entriesRelatedToClassNamed: self instanceSide name asString) asOrderedCollection ];
		column: 'Seq' text: [ :each | each value sequence ] width: 50;
		column: 'Artifact' text: [ :each | each key ];
		column: 'Action' text: [ :each | each value action ];
		column: 'Page' text: [ :each | each value pageTitle ifNil: [ '' ] ];
		column: 'Applied' text: [ :each | each value lastAppliedAt printString ];
		send: [ :each | each value resolvedSnippet ifNil: [ each value ] ]
]
