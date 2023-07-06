Class {
	#name : #BaselineOfDynaSpaceKnowledge,
	#superclass : #BaselineOf,
	#category : #BaselineOfDynaSpaceKnowledge
}

{ #category : #accessing }
BaselineOfDynaSpaceKnowledge class >> defaultKnowledgeBasePathName [
	^ 'lepiter'
]

{ #category : #'lepiter-store' }
BaselineOfDynaSpaceKnowledge class >> loadKnowledgeBase [
	self loadKnowledgeBaseForRepositoryNamed: 'dynaspace-knowledge'
]

{ #category : #'lepiter-store' }
BaselineOfDynaSpaceKnowledge class >> loadKnowledgeBaseForRepositoryNamed: aRepositoryName [
	self loadKnowledgeBaseForRepositoryNamed: aRepositoryName andPath: self defaultKnowledgeBasePathName
]

{ #category : #'lepiter-store' }
BaselineOfDynaSpaceKnowledge class >> loadKnowledgeBaseForRepositoryNamed: aRepositoryName andPath: aPathName [
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
BaselineOfDynaSpaceKnowledge >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'DynaSpaceKnowledge'
		]
]
