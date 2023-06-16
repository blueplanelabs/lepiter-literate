Class {
	#name : #BaselineOfDynaSpaceKnowledge,
	#superclass : #BaselineOf,
	#category : #BaselineOfDynaSpaceKnowledge
}

{ #category : #baseline }
BaselineOfDynaSpaceKnowledge >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'DynaSpaceKnowledge'
		]
]
