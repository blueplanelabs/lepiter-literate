Class {
	#name : #KnowledgeAssimilatorExamples,
	#superclass : #Object,
	#category : #'Lepiter-Literate-Examples'
}

{ #category : #support }
KnowledgeAssimilatorExamples >> exampleBuildTestKnowledgePage [
	<gtExample>
	| defaultDatabase |
	defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
	self removeIfNecessary.
	KnowledgeAssimilator
		processPage: (defaultDatabase
				pageNamed: 'Crear LePage  ejemplo para prueba de construcción de conocimiento').
	^ defaultDatabase pageNamed: 'Test Knowledge Page'
]

{ #category : #example }
KnowledgeAssimilatorExamples >> exampleProcessTestKnowledgePage [
	<gtExample>
	| page |
	self removeDummyClass.
	page := self exampleTestKnowledgePage.
	KnowledgeAssimilator processPage: page.
	"Comprobamos que se ha creado la clase y el método resultado de la asimiliación de conocimiento"
	self assert: Dummy doit equals: 42.
	self assert: Dummy methodCreatedByChangesSnippet.
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
	self assert: snippetsToProcess size equals: 6.
	^ snippetsToProcess
]

{ #category : #support }
KnowledgeAssimilatorExamples >> removeDummyClass [
	(SmalltalkImage current classNamed: #Dummy) ifNotNil: [ :classToRemove | classToRemove removeFromSystem ].
]

{ #category : #support }
KnowledgeAssimilatorExamples >> removeIfNecessary [
	LeDatabasesRegistry defaultLogicalDatabase
		pageNamed: 'Test Knowledge Page'
		ifPresent: [ :page | page removeSelf ]
		ifAbsent: [  ]
]
