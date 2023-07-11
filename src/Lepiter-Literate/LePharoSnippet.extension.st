Extension { #name : #LePharoSnippet }

{ #category : #'*Lepiter-Literate' }
LePharoSnippet >> assimilateWith: aKnowledgeAssimilatorClass [
	aKnowledgeAssimilatorClass processPharoSnippet: self
]

{ #category : #'*Lepiter-Literate' }
LePharoSnippet >> isKnowledge [
	^ true
]
