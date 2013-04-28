NPViewCollapser
===============

iOS class for collapsing views in a book closing style.

NPViewCollapser is used to apply a book-style folding effect to any view.

Usage
-----

Let's say you have a UIView called myCoolView.
You can enable the collapsing effect on it by creating an instance of NPViewCollapser and passing in your view.
```objc
NPViewCollapser *viewCollapser = [NPViewCollapser collapserWithView:myCoolView];
```

Collapsing the view is easy, just call collapseByAmount: on the corresponding viewCollapser.  The amount is a value between 0 and 1.  1 means the view is fully collapsed, 0 means it's fully open.  Any value in between represents intermediate states.
```objc
// Collapse the view half-way
[viewCollapser collapseByAmount:0.5f];
```

Animating
---------

NPViewCollapser doesn't support animations on its own.  CAAnimations didn't quite work as smoothly when applying complex transforms so they were left out.

That being said, it's still possible to animate the collapser manually.  Included with this project is another custom class called NPProgressTimer.


NPProgressTimer
---------------

NPProgressTimer is a simple class that allows you to run custom animations.  NPProgressTimer will manage time-keeping for you.  All you have to do is pass a block that will process individual steps of the animation.

For example, to use NPProgressTimer to animate NPViewCollapser collapsing you could initialize it like this.

```objc
NPProgressTimer *progressTimer = [NPProgressTimer timerWithDuration:0.3f
                                               			   stepSize:0.01f
                                       			   progressCallback:^(BOOL finished, double progress) {
													[viewCollapser collapseByAmount:progress];
												   }];
```

Once the progress timer is initialized, you can start it using one of the start methods.

```objc
[progressTimer start];
```