Extension { #name : #LeTableOfContentsNode }

{ #category : #'*Lepiter-Literate' }
LeTableOfContentsNode >> processKnowledge [
	KnowledgeAssimilator processPage: self page.
	self childrenDo: [ :node | node processKnowledge ]
]
