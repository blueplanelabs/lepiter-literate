Class {
	#name : #KnowledgeAssimilator,
	#superclass : #Object,
	#classInstVars : [
		'sharedBindingsToAdd'
	],
	#category : #'Lepiter-Literate-Core'
}

{ #category : #'processing knowledge' }
KnowledgeAssimilator class >> initializeSharedBindings [
	sharedBindingsToAdd := OrderedCollection empty
]

{ #category : #'processing knowledge' }
KnowledgeAssimilator class >> knowledgeSnippetsInPage: aLePage [
	^ aLePage
		allChildrenSnippetsMatching: [ :aSnippet | aSnippet isKnowledge ]
]

{ #category : #'processing knowledge' }
KnowledgeAssimilator class >> processChangesSnippet: aChangesSnippet [
	aChangesSnippet asSnippetViewModel changes
		ifNotNil: [ :someChanges | someChanges applyChanges ]
]

{ #category : #'processing knowledge' }
KnowledgeAssimilator class >> processKnowledgeSnippets: codeSnippets [
	self initializeSharedBindings.
	codeSnippets do: [ :aSnippet | aSnippet assimilateWith: self ]
]

{ #category : #'processing knowledge' }
KnowledgeAssimilator class >> processPage: aLePage [
	| knowledgeSnippets |
	knowledgeSnippets := self knowledgeSnippetsInPage: aLePage.
	self processKnowledgeSnippets: knowledgeSnippets
]

{ #category : #'processing knowledge' }
KnowledgeAssimilator class >> processPharoSnippet: aSnippet [
	| context localBindingsToAdd bindingsToAdd snippetEvaluationResult |
	localBindingsToAdd := OrderedCollection
			with: (GtLocalVariablesBindings new localAt: #thisSnippet put: aSnippet).
	bindingsToAdd := sharedBindingsToAdd copyWithAll: localBindingsToAdd.
	context := aSnippet coder evaluationContext.
	bindingsToAdd do: [ :aBindingToAdd | context addBindings: aBindingToAdd ].
	snippetEvaluationResult := aSnippet coder doItInContext: context.
	^ sharedBindingsToAdd := snippetEvaluationResult evaluationContext
			bindingStrategy bindings
			select: [ :aBinding | aBinding isKindOf: GtSharedVariablesBindings ]
]
