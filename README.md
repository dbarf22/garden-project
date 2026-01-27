### Live version posted on https://dbarf22.itch.io/garden-project

# About
This is a simple little project made inside of the Godot engine. You walk around as a little cat and you can either plant a flower or read a flower. Once a message is planted, anyone can see it and it expires after 24 hours. My main thought process behind making this was not only to give me a way to learn my way around a game engine for the first time, but also to make something that scratches an itch I've had for a while.

I've never known life without the internet, but I felt like the older I got, the more the internet began to stray away from what I thought it was. When I was younger, I always viewed it as this thing that simply had the ability to connect everyone- Steam chat rooms where you could talk to people about games, Reddit threads and random discussion forms with tight-knit communities for niche subjects, Blogger sites where you could read about peoples' lives and opinions, etc. It was just this giant collaborative network where all humans could express themselves and make cool websites. 

All of these things still exist, but I have felt like the naive, positive view of the internet has kind of withered away. Of course the internet has always been a place full of good and bad, but I feel like today it's more difficult than ever for us to simply control what we see from other human beings. Social media moved from chronological feeds to algorithmic feeds- no longer are we in full control of what we see. Instead, it feels like we are fed whatever makes us the most angry.

Platforms that once felt like places where we could express ourselves are now centralized and designed to harvest data and mold advertisements, which is kind of a disappointing feeling. I can't even go on Reddit anymore and know if a post is made by a real human, astroturfed bot accounts, or LLMs posting AI replies in comments to farm karma. 

This little project doesn't attempt to fix the internet. I ultimately just wanted to make a small, niche little space where people can just express themselves. You just type messages or read messages, that's about it. It's a tiny little place free of any type of algorithms or outside influence. It ties back to that old, probably naive idea of the internet I once had- a place to express things. It's a simple idea, but it was a good way to both get my feet wet with Godot and make something cute and fun.

# Technical Stuff
For the game, I used the latest version of Godot since I wanted a simple way to make an interactive environment with tilemaps. I initially started this project with Phaser. I knew that I wanted this to be a web experience, so I thought it would be fun to try an engine I'd never heard of. After messing around with a few different ideas for the visuals, I settled on a top-down tile-map based system. 

I tried thinking of "cozy" games when deciding what to do with the visuals, and for me the first thing that popped into my head was Pokemon Emerald. I created the tilemap in Tiled and got it configured inside of Phaser, but I started having aliasing issues between the tiles depending on the size of the browser window. Although this was a fixable problem, I realized for sake of efficiency it would be easier to just work on this project in a more established engine. 

I enjoyed Phaser, but their GUI editor didn't have a Linux version (as far as I am aware), so it ended up being very code intensive and kind of tedious to work with. Phaser did teach me a lot about HTML and JS however- I primarily only know C, C++, and Java. I ended up settling on Godot. I chose Godot mainly because I wanted to work with a more traditional game engine GUI with more established documentation. 

I'd never used GDScript, but I found the syntax to be very comparable to Python, so it ended up actually being very easy to use. The GUI of Godot also helps out with stuff like linking buttons to certain functions, so it made creating the UI elements really easy. I ended up using Supabase to store everything since it was a simple way to make a database and API that just adds and reads entries.

# Asset credits
https://schwarnhild.itch.io/basic-tileset-and-asset-pack-32x32-pixels

https://jennpixel.itch.io/free-flower-pack-12-icons

https://netherzapdos.itch.io/paws-whiskers-isometric-cats-pack

https://kaboff.itch.io/200-arrow-cursors-pack-32x32

https://fonts.google.com/specimen/Jersey+10

