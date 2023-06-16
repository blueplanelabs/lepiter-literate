Class {
	#name : #BaselineOfDynaSpaceKnowledge,
	#superclass : #BaselineOf,
	#category : #BaselineOfDynaSpaceKnowledge
}

{ #category : #'lepiter-store' }
BaselineOfDynaSpaceKnowledge class >> loadLepiter [
	IceRepository registry
		detect: [ :aRepository | aRepository name = 'dynaspace-knowledge' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties
				addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [ self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfDynaSpaceKnowledge >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'DynaSpaceKnowledge'
		]
]
