'From Cuis 5.0 of 7 November 2016 [latest update: #3129] on 20 July 2017 at 1:32:31 pm'!
'Description Please enter a description for this package'!
!provides: 'Mandelbrot-Set' 1 12!
!classDefinition: #MandelRectangle category: #'Mandelbrot-Set'!
Rectangle subclass: #MandelRectangle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mandelbrot-Set'!
!classDefinition: 'MandelRectangle class' category: #'Mandelbrot-Set'!
MandelRectangle class
	instanceVariableNames: ''!

!classDefinition: #Mandelbrot category: #'Mandelbrot-Set'!
Object subclass: #Mandelbrot
	instanceVariableNames: 'maxi graph width height scale origin range domain'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mandelbrot-Set'!
!classDefinition: 'Mandelbrot class' category: #'Mandelbrot-Set'!
Mandelbrot class
	instanceVariableNames: ''!


!MandelRectangle commentStamp: '<historical>' prior: 0!
A rectangle which retains the aspect of Mandelbrot Set graph.!

!Mandelbrot commentStamp: 'dhn 7/20/2017 13:00:37' prior: 0!
Do the following to display the complete Mandelbrot Set. In monochrome (takes about a minute; interruptable by Cmd-.):

	Mandelbrot demoOnce.
	
To display in monochrome and zoom in:

	Display restoreAfter: [Mandelbrot new zoom].
	
For successive detail in color (each takes a few minutes; interruptable by Cmd-.):

	Mandelbrot demoRepeat.

Points in consideration are represented by the complex numbers x + yi where x and y are in the intervals (-2.5, 1) and (-1, 1) respectively. Additional points are rendered to provide margins in the graph.!

!MandelRectangle class methodsFor: 'instance creation' stamp: 'dhn 7/6/2017 18:20:08'!
fromUser
	"Answer a Rectangle that is determined by having the user designate 
	the top left and bottom right corners, keeping the aspect ratio of the graph."
	| originRect delta p |
	
	delta _ 1.0 * (Mandelbrot extent y / Mandelbrot extent x).
	{delta} print.
	originRect _ Cursor origin showWhile: 
		[(Sensor mousePoint extent: 0@0) newRectFrom:
			[:f | Sensor mousePoint  extent: 0@0]].
	^ Cursor corner showWhile:
		[originRect newRectFrom:
			[:f | 
				p _ Sensor mousePoint.
				"p _ p x @ (p x * delta * 1.0)."
				f origin corner: p * (1@delta)]]! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 6/14/2017 11:55:49'!
colorFor: aCount
	"Answer the color for aCount"
	
	aCount > maxi
		ifTrue: [^ Color black].
	^ self class colors atWrap: aCount
		! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 6/14/2017 11:35:57'!
cycle
	"Iterate through all the points of graph, plotting in color"
	| x y w h |
	
	w _ 3.5 / graph width. 	"scale the width to (-2.5,1)"
	h _ 3.0 / graph height. 	"scale the height to (-1.5,1.5)"
	1 to: graph height do: [:n | 
		1 to: graph width do: [:m | 
			x _ (m * w) - 2.5. 	"translate to (-2.5,1)"
			y _ (n * h) - 1.5. 		"translate to (-1.5,1.5)"
			graph  colorAt: (m@n) put: (self colorFor: (self testX: x Y: y))]]! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 6/24/2017 14:55:30'!
doit
	"Iterate through all the points of graph, plotting in monochrome"
	| x y w h dw dh |
	
	w _ self width.
	h _ self height.
	dw _ range x * scale x.
	dh _ domain x * scale y.
	1 to: graph height do: [:n | 
		1 to: graph width do: [:m | 
			x _ (m * w) + dw.
			y _ (n * h) + dh.
			graph  colorAt: (m@n) put: (self monochromeFor: (self testX: x Y: y))]]! !

!Mandelbrot methodsFor: 'access' stamp: 'dhn 5/29/2017 15:15:27'!
graph
	"Answer the value of graph"
	
	^ graph! !

!Mandelbrot methodsFor: 'access' stamp: 'dhn 6/14/2017 17:07:35'!
height
	"Answer the value of height"
	
	height ifNil: [height _ 3.0 / graph height]. 	"scale the height to (-1.5,1.5)"
	^ height! !

!Mandelbrot methodsFor: 'initialization' stamp: 'dhn 6/24/2017 14:45:36'!
initialize
	
	maxi _ 100.
	graph _ Form extent: self class extent depth: 8.
	scale _ 1@1.
	origin _ -2.5@-1.5.
	range _ -2.5@1.0.
	domain _ -1.5@1.5
! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 6/3/2017 19:38:49'!
monochromeFor: aCount
	"Answer the pixel color for aCount"
	
	aCount > maxi
		ifTrue: [^ Color black].
	^ Color white
		! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 7/20/2017 12:56:24'!
once
	"Display the Mandelbrot Set one time"

	self doit.
	graph displayAt: 20@0! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 7/20/2017 13:29:04'!
repeat
	"Display the Mandelbrot Set in successive color detail. Each rendering may consume several minutes."
	"The array below contains the number of iterations for a point  to be considered in the set."
	
	#(8 16 32 64 128) do: [:ea |
		maxi _ ea.
		Display restore.	
		self cycle.
		graph displayAt: 20@0.
		{ea} print]
	
	"Values in the array specify the number of iterations for the orbit about 0 of a point in the complex plane to remain small (not diverge).  Such a point is considered in the set."! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 5/30/2017 14:24:04'!
step
	"Iterate through all the points of graph, plotting colors"
	| x y w h z |
	
	w _ 3.5 / graph width. 	"scale the width to (-2.5,1)"
	h _ 2.0 / graph height. 	"scale the height to (-1,1)"
	1 to: graph width do: [:m | 
		1 to: graph height do: [:n | 
			x _ (m * w) - 2.5. 	"translate to (-2.5,1)"
			y _ (n * h) - 1.0. 		"translate to (-1,1)"
			z _ self testX: x Y: y.
			((y > 0) and: [z > 4]) ifTrue: [
				{m. n. z} print.
				self halt]]]! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 5/30/2017 11:40:16'!
testX: valueX Y: valueY
	"Answer the iterations needed to decide whether valueX@valueY might be in the set"
	| x y x2 y2 newX newY i |
	
	x _ valueX.
	y _ valueY.
	
	i _ 0.
	[maxi isNil] whileFalse: [
		(i _ i + 1) > maxi ifTrue: [ ^ i ].
		x2 _ x*x.
		y2 _ y*y.
		((x2 + y2) > 4.1) ifTrue: [ ^ i ].
		newX _ x2 - y2 + valueX.
		newY _ 2*x*y + valueY.
		x _ newX.
		y _ newY].
	^ i! !

!Mandelbrot methodsFor: 'access' stamp: 'dhn 6/14/2017 17:00:31'!
width
	"Answer the value of width"
	
	width ifNil: [width _ 3.5 / graph width]. 	"scale the width to (-2.5,1)"
	^ width! !

!Mandelbrot methodsFor: 'operation' stamp: 'dhn 6/24/2017 15:08:04'!
zoom
	"Display the set and enable user to draw a zoom rectangle"
	| rect |
	
	[true] whileTrue: [
		self doit.
		graph displayAt: 20@0.
		rect _ MandelRectangle fromUser.
		origin _ rect origin.
		scale _ rect extent / graph extent.
		range _ range * scale x.
		domain _ domain * scale y.
		{scale. range. domain} print]

! !

!Mandelbrot class methodsFor: 'accessing' stamp: 'dhn 5/30/2017 15:58:45'!
colors
	"Answer the colors for points outside the set"
	
	^ Color brightColorDict asOrderedCollection! !

!Mandelbrot class methodsFor: 'instance creation' stamp: 'dhn 7/20/2017 12:48:21'!
demoOnce
	"Display the Mandelbrot set in monochrome, pause, then erase"
	"
	Mandelbrot demoOnce.
	"
	
	Mandelbrot new once.
	(Delay forSeconds: 5) wait.
	Display restore! !

!Mandelbrot class methodsFor: 'instance creation' stamp: 'dhn 7/20/2017 12:43:53'!
demoRepeat
	"Display the Mandelbrot set in a succession of refinement, pause, then erase"
	"
	Mandelbrot demoRepeat.
	"
	
	Mandelbrot new repeat.
	(Delay forSeconds: 5) wait.
	Display restore! !

!Mandelbrot class methodsFor: 'accessing' stamp: 'dhn 6/3/2017 19:26:10'!
extent
	"Answer the extent of the form for the drawing"
	
	^ 1200@960! !
