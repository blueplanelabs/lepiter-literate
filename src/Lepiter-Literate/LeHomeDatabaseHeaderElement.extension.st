Extension { #name : #LeHomeDatabaseHeaderElement }

{ #category : #'*Lepiter-Literate' }
LeHomeDatabaseHeaderElement >> initialize [
	super initialize.
	self initializeEditableTitleElement.
	self initializeButtons.
	
	self addChild: self toolbarElement as: #toolbar.
	self toolbarElement 
		addItem: self editableTitleElement;
		addItem: self newAddNewPageButton;
		addItem: self removeButtonElement;
		addItem: self importButtonElement;
		addItem: self exportButtonElement;
		addItem: self newTangleButton.
	
	self addAptitude: (BrLayoutResizerAptitude new
		hInherit;
		vAnyToFitContent; 
		hInherit: self toolbarElement;
		vAnyToFitContent: self toolbarElement).
]

{ #category : #'*Lepiter-Literate' }
LeHomeDatabaseHeaderElement >> newTangleButton [
		^ BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			beTinySize;
			label: 'Tangle ToC pages';
			icon: BrGlamorousVectorIcons play;
			action: [ :aButton | self database tangleTableOfContentsOutgoingLinks ];
			margin: (BlInsets left: 10)
]
