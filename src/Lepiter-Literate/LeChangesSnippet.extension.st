Extension { #name : #LeChangesSnippet }

{ #category : #'*Lepiter-Literate' }
LeChangesSnippet >> assimilateWith: aKnowledgeAssimilatorClass [
	aKnowledgeAssimilatorClass processChangesSnippet: self
]

{ #category : #'*Lepiter-Literate' }
LeChangesSnippet >> isKnowledge [
	^ true
]
