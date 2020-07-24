# Infinite Canvas

This example project shows how to create an "infinite" canvas using PencilKit. It's not really infinite though but it's a canvas so huge that users will most likely regard it infinite.

<img src="https://github.com/simonbs/infinite-canvas/raw/main/screenshot.jpeg" width="200"/>

The approach is the following:

1. Create a very huge canvas. I'm using 1000000 x 1000000.
2. Place the user in the middle of the canvas.
3. Help the user navigate the very large canvas. I'm using arrows on the edges of the screen to show where the user can scroll to see more of the drawing. You could also use a minimap to achieve the same goal.

When doing state restoration, you don't want to place the user in the middle of the canvas. Instead you should place the user in the middle of their drawing.

I use the [strokes property of a PKDrawing](https://developer.apple.com/documentation/pencilkit/pkdrawing/3595078-strokes) to calculate the frame of a drawing in the canvas. This is needed to show the arrows that help the user navigate the canvas.

## Licenses

All source code is licensed under the [MIT License](https://github.com/simonbs/InfiniteCanvas/).
