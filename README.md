<p>Submission to Godot Wild Jam #68 under the game title 'It's an "Honest" Work'. A simple stealth game combined with pixel painting and mesh sculpting made in Godot. Written in GDScript for Godot 3.5.3 Stable. Feel free to use the game as a template, learning base, or sample for your project.</p> 
<p>Note, you will need to fix dependencies for the BGM before playtesting the game. Simply find any line in the scripts provided that has the following code <strong>AudioManager.change_bgm([BGM_TITLE])</strong> and change it to <u><strong>AudioManager.change_bgm("")</strong></u>.</p>
<p>You will also need to remove the audio from the stream property in the BGM node in the AudioManager.tscn scene.</p>
<p>Note: Will not probably work for Godot 4 without major modifications.</p>
