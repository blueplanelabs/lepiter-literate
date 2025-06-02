Extension { #name : #LeDatabase }

{ #category : #'*Lepiter-Literate' }
LeDatabase >> processKnowledge [
	self tableOfContentsNodes first processKnowledge
]
