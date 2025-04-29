# Godot Graph Visualizer

Hiii, im SamKerubin :3

Im currently working on this new awesome idea i got...

Let me explain you how it will work

## What are you planning to do?

Well... Im trying to make a project visualizer for your projects in godot!

What does that exactly means?

All your files, scenes, scripts, even resources will be displayed at the editor in a graph-way

## Oh, ok cool... But why?

Simple :D I thought that this will be something really helpful for anyone having troubles with project organization

*Why?*

Because this plugin allows you to see **ALL** files relations... For example: you have 2 scenes: A.tscn and B.tscn, B.tscn have a reference as a preload to A.tscn:

> ***var scene_a = preload("res://A.tscn")***

This plugin will allow you to see that reference in the editor, making it so much easier to see any relation between scenes, scripts or resources

This feature also applies to ".new()" or ".instantiate()" methods

## Why is it helpful?

As i previously said, it helps with project organization, and also can make searching dependeces of a node so much easier and simpler

Also, it gives you a very clean idea of what the heck is happening in your project in case you left for months or so

To make it more clear:

> ***Player.tscn***
>
> ***|_ HealthComponent.tscn***

In the editor, it will display like this:

> ***Player --- instantiate ---> HealthComponent***

*NOTE: THIS SYNTAX IS JUST AN EXAMPLE AND MAY BE UP TO CHANGES*

## Thanks for reading

Thats all for now! I will update this repository frequently, so... Feel free to contact me via Mail or maybe Instagram

- Email: samuelkiller2013@gmail.com
- Instagram: [@SamKerubin](https://www.instagram.com/samkerubin/)

Also, thanks for reading, contact me if you have any suggestion for my project!

Ily <3!

:3
