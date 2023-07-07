Class {
	#name : #BaselineOfLepiterLiterate,
	#superclass : #BaselineOf,
	#category : #BaselineOfLepiterLiterate
}

{ #category : #accessing }
BaselineOfLepiterLiterate class >> defaultKnowledgeBasePathName [
	^ 'lepiter'
]

{ #category : #'lepiter-store' }
BaselineOfLepiterLiterate class >> loadKnowledgeBase [
	self loadKnowledgeBaseForRepositoryNamed: 'dynaspace-knowledge'
]

{ #category : #'lepiter-store' }
BaselineOfLepiterLiterate class >> loadKnowledgeBaseForRepositoryNamed: aRepositoryName [
	self loadKnowledgeBaseForRepositoryNamed: aRepositoryName andPath: self defaultKnowledgeBasePathName
]

{ #category : #'lepiter-store' }
BaselineOfLepiterLiterate class >> loadKnowledgeBaseForRepositoryNamed: aRepositoryName andPath: aPathName [
	IceRepository registry
		detect: [ :aRepository | aRepository name = aRepositoryName ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties
				addRegisteredDirectory: aRepository repositoryDirectory / aPathName.
			defaultDatabase reload ]
		ifNone: [ self inform: 'Repository ', aRepositoryName, ' not found.' ]
]

{ #category : #baseline }
BaselineOfLepiterLiterate >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Lepiter-Literate'
		]
]
