# Advanced Vision

In collaboration with Georgi Tinchev.
In this task, we had to detect dancing people on the video. We achieved this by utilising colour histograms and motion tracker, which was based on prior knowledge that between consecutive frames people couldn't move too far away from their previous positions.

Report is at [Advanced_Vision_1.pdf]

Our code was quite fast for Matlab and produced 3-5 frames per second which  Mainly it was attained due to the simple and efficient tracker. Similar solution based on particle filter'а (condensation tracker) worked much slower (0.3 frames per second) and required a lot of manual adjustment.

Final result

![final result](av_1_anim.gif)
