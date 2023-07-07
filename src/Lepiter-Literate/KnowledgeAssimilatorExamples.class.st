Class {
	#name : #KnowledgeAssimilatorExamples,
	#superclass : #Object,
	#category : #'Lepiter-Literate-Examples'
}

{ #category : #example }
KnowledgeAssimilatorExamples >> exampleProcessTestKnowledgePage [
	<gtExample>
	| page |
	page := self exampleTestKnowledgePage.
	KnowledgeAssimilator processPage: page.
	"Comprobamos que se ha creado la página resultado de la asimiliación de conocimiento"
	self assert: Dummy doit equals: 42.
	^ page

]

{ #category : #example }
KnowledgeAssimilatorExamples >> exampleTestKnowledgePage [
	<gtExample>
	| defaultDatabase targetPageName |
	defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
	targetPageName := 'Test Knowledge Page'.
	^ defaultDatabase pageNamed: targetPageName
]

{ #category : #example }
KnowledgeAssimilatorExamples >> exampleTestKnowledgePageSnippetsToProcess [
	<gtExample>
	| testPage snippetsToProcess |
	testPage := self exampleTestKnowledgePage.
	snippetsToProcess := KnowledgeAssimilator knowledgeSnippetsInPage: testPage.
	self assert: snippetsToProcess size equals: 4.
	^ snippetsToProcess
]
