Extension { #name : #LePage }

{ #category : #'*Lepiter-Literate' }
LePage >> gtTangleActionFor: anAction [
	<lePageAction>

	^ anAction button 
		tooltip: 'Tangle all code snippets in this page';
		icon: BrGlamorousVectorIcons play ;
		action: [ :aButton | KnowledgeAssimilator processPage: self ]
]
