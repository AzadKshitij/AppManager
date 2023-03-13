extends Button

var thread: Thread

var path = ""

func _on_pressed():
	thread = Thread.new()
	thread.start(_thread, Thread.PRIORITY_NORMAL)
	while thread.is_alive():
		await get_tree().process_frame
	thread.wait_to_finish()
	thread = null

func _thread():
	OS.execute(path, [])
