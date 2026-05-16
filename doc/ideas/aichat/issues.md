# bugs

# minor

When tools are used, the interface jumps around because the tools collapsible expands and contracts. Keep tool display collapsed.
Memory is kinda wasteful, It runs on every turn but it only saves things that I specifically say should be saved. Use custom memory server.
Models keep talking/thinking about memory injected into chat, needs some prompting to guide them. can be confusing for user if model talks, overall suboptimal.

Very strange issue when sending a large message with context files and a big prompt to a model provider never used before. Libre returns an error that the message exceeds the maximum context of 1024 tokens.
- Some configuration tweaks, but apparently no solution.
- If the first message is very short, like hi, Libre will talk to the API and automatically override the system value of 1024 maximum tokens with whatever the API said is the right value. After this it works?

Sometimes when sending a message, the input box is not cleared immediately while the model is processing the message. The clear is delayed a few seconds.

# personal preferences

- tool call input display is truncated, with output first. Do not truncate input, show input first.
- side bar has min width, can't resize to be smaller. Set width to widest child.
- cannot organize chats by folder or project or in any way whatsoever, they just pile up in an endless scroll list. #4848 in libre.
    simple: drag and drop chats together to create a directory, right click a directory to rename it. Drag chats out to move. Zero chats: dir is deleted.
    nice to have: claude code organize, sort by, clone.
- cannot send a message while the model is working on the previous message, even though the turn has already progressed to a tool call. This is supported in Cloud Code.