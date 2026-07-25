Class {
	#name : 'LeLiterateProvenanceExamples',
	#superclass : 'Object',
	#category : 'Lepiter-Literate-Examples',
	#package : 'Lepiter-Literate',
	#tag : 'Examples'
}

{ #category : 'examples' }
LeLiterateProvenanceExamples >> classAnswersItsLiterateOriginView [
	<gtExample>
	| db page creatorSnippet modifierSnippet related view |
	self removeProbeClasses.
	LeLiterateProvenance resetDefault.
	LeLiterateProvenance default addInterestingPackageNamed: 'LeLiterateProvenanceProbe'.
	db := LeDatabase new.
	page := db pageBuilder title: 'Página que crea la clase'; add.
	creatorSnippet := LePharoSnippet new code: '"crea la clase y el método"'.
	modifierSnippet := LePharoSnippet new code: '"modifica el método"'.
	page addSnippet: creatorSnippet.
	page addSnippet: modifierSnippet.
	LeLiterateProvenance default
		capturingFor: creatorSnippet
		during: [
			Object subclass: #LeLiterateProbeSubject
				instanceVariableNames: '' classVariableNames: '' category: 'LeLiterateProvenanceProbe'.
			(Smalltalk classNamed: #LeLiterateProbeSubject) compile: 'answer ^ 42' classified: 'accessing' ].
	LeLiterateProvenance default
		capturingFor: modifierSnippet
		during: [
			(Smalltalk classNamed: #LeLiterateProbeSubject) compile: 'answer ^ 43' classified: 'accessing' ].
	related := LeLiterateProvenance default entriesRelatedToClassNamed: 'LeLiterateProbeSubject'.
	self assert: related size equals: 3.
	self assert: (related collect: [ :each | each value sequence ]) asArray isSorted.
	view := (Smalltalk classNamed: #LeLiterateProbeSubject) gtLiterateOriginFor: GtPhlowView empty.
	self assert: view class equals: GtPhlowColumnedListView.
	"Una clase sin traza responde la vista vacía"
	self assert: (LeLiterateProvenanceExamples gtLiterateOriginFor: GtPhlowView empty) class
		equals: GtPhlowEmptyView.
	^ view
]

{ #category : 'examples' }
LeLiterateProvenanceExamples >> entryRecordsItsOrigin [
	<gtExample>
	| db page snippet entry |
	db := LeDatabase new.
	page := db pageBuilder title: 'Página de origen'; add.
	snippet := LePharoSnippet new code: '1 + 1'.
	page addSnippet: snippet.
	entry := LeLiterateProvenanceEntry forSnippet: snippet action: #created sequence: 1.
	self assert: entry snippetUid equals: snippet uid.
	self assert: entry pageTitle equals: 'Página de origen'.
	self assert: entry action equals: #created.
	self assert: entry sequence equals: 1.
	self assert: entry lastAppliedAt notNil.
	^ entry
]

{ #category : 'examples' }
LeLiterateProvenanceExamples >> historyKeepsOrderAndIsIdempotent [
	<gtExample>
	| db page snippetA snippetB history entryA entryB refreshedA |
	db := LeDatabase new.
	page := db pageBuilder title: 'Página de origen'; add.
	snippetA := LePharoSnippet new code: '1 + 1'.
	snippetB := LePharoSnippet new code: '2 + 2'.
	page addSnippet: snippetA.
	page addSnippet: snippetB.
	history := LeLiterateCodeHistory new.
	entryA := LeLiterateProvenanceEntry forSnippet: snippetA action: #created sequence: 1.
	entryB := LeLiterateProvenanceEntry forSnippet: snippetB action: #modified sequence: 2.
	history addEntry: entryA.
	history addEntry: entryB.
	self assert: history size equals: 2.
	self assert: history entries first action equals: #created.
	self assert: history entries second action equals: #modified.
	"Volver a aplicar el mismo snippet no duplica la entrada: la refresca"
	refreshedA := LeLiterateProvenanceEntry forSnippet: snippetA action: #modified sequence: 3.
	history addEntry: refreshedA.
	self assert: history size equals: 2.
	self assert: history entries first snippetUid equals: snippetA uid.
	self assert: history entries first action equals: #created.
	self assert: history entries first lastAppliedAt equals: refreshedA lastAppliedAt.
	^ history
]

{ #category : 'examples' }
LeLiterateProvenanceExamples >> registryAttributesDefinitionsToTheSnippet [
	<gtExample>
	| registry db page snippet classHistory methodHistory |
	self removeProbeClasses.
	registry := LeLiterateProvenance new.
	registry addInterestingPackageNamed: 'LeLiterateProvenanceProbe'.
	db := LeDatabase new.
	page := db pageBuilder title: 'Página que define la clase'; add.
	snippet := LePharoSnippet new code: '"define la clase de prueba"'.
	page addSnippet: snippet.
	registry
		capturingFor: snippet
		during: [
			Object subclass: #LeLiterateProbeSubject
				instanceVariableNames: '' classVariableNames: '' category: 'LeLiterateProvenanceProbe'.
			(Smalltalk classNamed: #LeLiterateProbeSubject) compile: 'answer ^ 42' classified: 'accessing' ].
	classHistory := registry historyForKey: 'LeLiterateProbeSubject'.
	methodHistory := registry historyForKey: 'LeLiterateProbeSubject>>#answer'.
	self assert: classHistory size equals: 1.
	self assert: classHistory entries first action equals: #created.
	self assert: classHistory entries first snippetUid equals: snippet uid.
	self assert: classHistory entries first pageTitle equals: 'Página que define la clase'.
	self assert: methodHistory size equals: 1.
	self assert: methodHistory entries first action equals: #created.
	^ registry
]

{ #category : 'examples' }
LeLiterateProvenanceExamples >> registryIgnoresPackagesOutsideTheFilter [
	<gtExample>
	| registry db page snippet |
	self removeProbeClasses.
	registry := LeLiterateProvenance new.
	registry addInterestingPackageNamed: 'LeLiterateProvenanceProbe'.
	db := LeDatabase new.
	page := db pageBuilder title: 'Página con código ajeno'; add.
	snippet := LePharoSnippet new code: '"define una clase fuera del filtro"'.
	page addSnippet: snippet.
	registry
		capturingFor: snippet
		during: [
			Object subclass: #LeLiterateOtherProbeSubject
				instanceVariableNames: '' classVariableNames: '' category: 'LeLiterateProvenanceOtherProbe' ].
	self assert: (registry historyForKey: 'LeLiterateOtherProbeSubject') isEmpty.
	self assert: registry artifactKeys isEmpty.
	^ registry
]

{ #category : 'examples' }
LeLiterateProvenanceExamples >> registryTracksModificationOrderAcrossSnippets [
	<gtExample>
	| registry db page creatorSnippet modifierSnippet methodHistory |
	self removeProbeClasses.
	registry := LeLiterateProvenance new.
	registry addInterestingPackageNamed: 'LeLiterateProvenanceProbe'.
	db := LeDatabase new.
	page := db pageBuilder title: 'Página que crea la clase'; add.
	creatorSnippet := LePharoSnippet new code: '"crea la clase y el método"'.
	modifierSnippet := LePharoSnippet new code: '"modifica el método"'.
	page addSnippet: creatorSnippet.
	page addSnippet: modifierSnippet.
	registry
		capturingFor: creatorSnippet
		during: [
			Object subclass: #LeLiterateProbeSubject
				instanceVariableNames: '' classVariableNames: '' category: 'LeLiterateProvenanceProbe'.
			(Smalltalk classNamed: #LeLiterateProbeSubject) compile: 'answer ^ 42' classified: 'accessing' ].
	registry
		capturingFor: modifierSnippet
		during: [
			(Smalltalk classNamed: #LeLiterateProbeSubject) compile: 'answer ^ 43' classified: 'accessing' ].
	methodHistory := registry historyForKey: 'LeLiterateProbeSubject>>#answer'.
	self assert: methodHistory size equals: 2.
	self assert: methodHistory entries first action equals: #created.
	self assert: methodHistory entries first snippetUid equals: creatorSnippet uid.
	self assert: methodHistory entries second action equals: #modified.
	self assert: methodHistory entries second snippetUid equals: modifierSnippet uid.
	self assert: methodHistory entries first sequence < methodHistory entries second sequence.
	^ methodHistory
]

{ #category : 'support' }
LeLiterateProvenanceExamples >> removeProbeClasses [
	(Smalltalk classNamed: #LeLiterateProbeSubject) ifNotNil: [ :aClass | aClass removeFromSystem ].
	(Smalltalk classNamed: #LeLiterateOtherProbeSubject) ifNotNil: [ :aClass | aClass removeFromSystem ]
]

{ #category : 'examples' }
LeLiterateProvenanceExamples >> snippetAnswersItsGeneratedCodeView [
	<gtExample>
	| db page creatorSnippet inverse view |
	self removeProbeClasses.
	LeLiterateProvenance resetDefault.
	LeLiterateProvenance default addInterestingPackageNamed: 'LeLiterateProvenanceProbe'.
	db := LeDatabase new.
	page := db pageBuilder title: 'Página que crea la clase'; add.
	creatorSnippet := LePharoSnippet new code: '"crea la clase y el método"'.
	page addSnippet: creatorSnippet.
	LeLiterateProvenance default
		capturingFor: creatorSnippet
		during: [
			Object subclass: #LeLiterateProbeSubject
				instanceVariableNames: '' classVariableNames: '' category: 'LeLiterateProvenanceProbe'.
			(Smalltalk classNamed: #LeLiterateProbeSubject) compile: 'answer ^ 42' classified: 'accessing' ].
	inverse := LeLiterateProvenance default entriesForSnippetUidString: creatorSnippet uid uidString.
	self assert: (inverse collect: [ :each | each key ]) asArray
		equals: { 'LeLiterateProbeSubject'. 'LeLiterateProbeSubject>>#answer' }.
	view := creatorSnippet gtGeneratedCodeFor: GtPhlowView empty.
	self assert: view class equals: GtPhlowColumnedListView.
	"Las claves se resuelven a los artefactos vivos"
	self assert: (LeLiterateProvenance default artifactForKey: 'LeLiterateProbeSubject')
		equals: (Smalltalk classNamed: #LeLiterateProbeSubject).
	self assert: (LeLiterateProvenance default artifactForKey: 'LeLiterateProbeSubject>>#answer') selector
		equals: #answer.
	^ view
]

{ #category : 'examples' }
LeLiterateProvenanceExamples >> tangleRecordsProvenanceThroughTheAssimilator [
	<gtExample>
	| quote db page snippet registry |
	self removeProbeClasses.
	LeLiterateProvenance resetDefault.
	LeLiterateProvenance default addInterestingPackageNamed: 'LeLiterateProvenanceProbe'.
	quote := String with: $'.
	db := LeDatabase new.
	page := db pageBuilder title: 'Página tangleada'; add.
	snippet := LePharoSnippet new
		code: ('Object subclass: #LeLiterateProbeSubject instanceVariableNames: {q}{q} classVariableNames: {q}{q} category: {q}LeLiterateProvenanceProbe{q}'
			copyReplaceAll: '{q}' with: quote).
	page addSnippet: snippet.
	KnowledgeAssimilator processPage: page.
	registry := LeLiterateProvenance default.
	self assert: (registry historyForKey: 'LeLiterateProbeSubject') size equals: 1.
	self assert: (registry historyForKey: 'LeLiterateProbeSubject') entries first action equals: #created.
	self assert: (registry historyForKey: 'LeLiterateProbeSubject') entries first snippetUid equals: snippet uid.
	^ registry
]
