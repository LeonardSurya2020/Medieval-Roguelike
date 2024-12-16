extends Node2D

# Daftar ruangan platform yang akan digunakan (berisi scene path dan ukuran)
@export var rooms = [
	{"path": "res://Scenes/Biome/Biome 1-1/biome_1_1_1.tscn", "size": Vector2(36, 36)},  # Room utama
	{"path": "res://Scenes/Biome/Biome 1-1/biome_1_1_2.tscn", "size": Vector2(36, 36)},  # Room tambahan 1
	{"path": "res://Scenes/Biome/Biome 1-1/biome_1_1_3.tscn", "size": Vector2(39, 36)},  # Room tambahan 2 (muncul sekali, tidak di akhir)
	{"path": "res://Scenes/Biome/Biome 1-1/biome_1_1_4.tscn", "size": Vector2(36, 36)},  # Room tambahan 3
	{"path": "res://Scenes/Biome/Biome 1-1/biome_1_1_5.tscn", "size": Vector2(40, 36)}   # Room akhir
]

var room_name
var grid_layout
var positioning
# Ukuran tile (64x64 piksel)
var tile_size = 64

# Ukuran grid dungeon berdasarkan ukuran ruangan dalam tile
var default_room_size = Vector2(36, 36)  # Ukuran default untuk room utama dan room tambahan
var room_spacing = Vector2(default_room_size.x * tile_size, default_room_size.y * tile_size)

# Ukuran grid untuk menentukan berapa ruangan akan digenerate dalam 1 level
var grid_size = Vector2(10, 3)  # Misalnya grid 10x3

# Untuk memastikan dungeon hanya digenerate sekali
var dungeon_generated = false

# Fungsi utama untuk generate dungeon platformer
func _ready():
	if SaveLoad.save_data.has("biome_layout") and SaveLoad.save_data["biome_layout"].size() >0:
		load_data()
	else:
		generate_dungeon()  # Memanggil fungsi generate saat scene dimulai

func generate_dungeon():
	if dungeon_generated:  # Jika dungeon sudah digenerate, hentikan proses
		return
	dungeon_generated = true  # Tandai bahwa dungeon sedang digenerate
	
	randomize()  # Acak agar setiap kali dijalankan hasilnya berbeda

	# Untuk melacak posisi grid yang sudah terisi
	var grid = []
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(false)  # Awalnya, semua sel grid belum terisi ruangan

	# Mulai dari posisi awal grid
	var current_position = Vector2(0, 0)
	grid[current_position.x][current_position.y] = true

	# Generate ruangan utama (room utama) di posisi awal (0, 0 dalam world space)
	instance_room(rooms[0], current_position, Vector2(0, 0))
	room_name = rooms[0]
	grid_layout = current_position
	save_room_data()

	# Variable untuk menandai posisi ruangan spesial dan akhir
	var special_room_position = null
	var special_room_placed = false
	var available_positions = []  # Posisi potensial untuk ruangan tambahan
	var end_room_position = null

	# Generate ruangan tambahan secara acak ke kanan
	var number_of_rooms_to_generate = rooms.size() # Misalnya, generate 5 ruangan tambahan
	for i in range(number_of_rooms_to_generate):
		var new_position = Vector2(i + 1, 0)  # Posisi baru ke kanan
		
		print("i ke", i)
		print("new position ke ", new_position)
		if new_position.x >= 0 and new_position.x < grid_size.x and new_position.y >= 0 and new_position.y < grid_size.y:
			if not grid[new_position.x][new_position.y]:
				available_positions.append(new_position)  # Simpan posisi yang tersedia
				
				# Pilih ruangan secara acak dari index 1, 2, 3 untuk menghindari ruangan akhir dan spesial
				var room_index = randi_range(1, 3)  # Pilih dari index 1, 2, 3
				print("index yang didapatkan = ", room_index)
				if special_room_placed == false and room_index == 2 and available_positions.size() > 0 && new_position != Vector2(5,0):
					# Tempatkan ruangan spesial hanya sekali jika belum ditempatkan
					special_room_position = new_position
					special_room_placed = true
					instance_room(rooms[2], special_room_position, special_room_position * room_spacing)
					room_name = rooms[2]
					grid[new_position.x][new_position.y] = true  # Tandai grid ini sudah terisi
					grid_layout = new_position
					save_room_data()
					
					print("Generated special room at position ", special_room_position)
				elif room_index != 2 and i < 4 and new_position != Vector2(5,0):
					instance_room(rooms[room_index], new_position, new_position * room_spacing)
					grid[new_position.x][new_position.y] = true  # Tandai grid ini sudah terisi
					print("Generated room at position ", new_position, " with room: ", rooms[room_index].path)
					room_name = rooms[room_index]
					grid_layout = new_position
					save_room_data()
				else:
					print("index ke " , room_index , " sudah di isi")
					
					# Jika new_position diantara (1,0) sampai (4,0) dan mendapatkan index ke-2 lebih dari satu kali
					# maka akan mengenerate room ulang
					if new_position != Vector2(5,0):
						var new_room_index = randi_range(0, 1) * 2 + 1 # hanya menghasilkan index 1 atau 3
						print("room akan digantikan lagi dengan index", new_room_index)
						instance_room(rooms[new_room_index], new_position, new_position * room_spacing)
						room_name = rooms[room_index]
						grid_layout = new_position
						save_room_data()
			else:
				print("Position ", new_position, " already occupied")

	# Tempatkan ruangan akhir di posisi acak terakhir setelah semua ruangan lainnya
	if available_positions.size() > 0:
		#available_positions.append(Vector2(5,0))
		end_room_position = available_positions.pop_back()  # Ambil posisi terakhir dari posisi yang tersedia
		instance_room(rooms[4], end_room_position, end_room_position * room_spacing)
		# Save Layout biome
		grid_layout = end_room_position
		room_name = rooms[4]
		save_room_data()
		print("Generated end room at position ", end_room_position)

# Fungsi untuk menginstansikan ruangan di posisi tertentu
func instance_room(room_data, grid_position, world_position):
	print("Instantiating room: ", room_data.path)  # Debugging: tampilkan path scene
	var room_instance = load(room_data.path).instantiate()
	if room_instance:
		# Menyesuaikan ukuran dan spacing berdasarkan ukuran ruangan yang berbeda
		var room_size = room_data.size
		if typeof(room_size) == TYPE_STRING:
			print("ubah ke vector2")
			var converted_vector = string_to_vector2(room_size)
			print("tipe nya menjadi ", typeof(converted_vector))
			var adjusted_spacing = Vector2(converted_vector.x * tile_size, converted_vector.y * tile_size)
		else :
			var adjusted_spacing = Vector2(room_size.x * tile_size, room_size.y * tile_size)
		# Tempatkan ruangan di posisi world yang dihitung berdasarkan grid dan tile size
		room_instance.position = world_position
		positioning = world_position
		add_child(room_instance)  # Tambahkan ruangan ke scene utama
		print("Ruangan ditempatkan di grid ", grid_position, " pada posisi world: ", world_position)
	else:
		print("Failed to load scene: ", room_data.path)

#func save_room_data():
	#SaveLoad.biome_layout[grid_layout] = {
		#"room_name" = room_name,
		#"grid_position" = grid_layout,
		#"x" = positioning.x,
		#"y" = positioning.y
	#}
	#SaveLoad.save_data["biome_layout"] = SaveLoad.biome_layout
	#SaveLoad.save_game()
	#print("data layout insert : ", SaveLoad.save_data)
#
#
#func load_data():
	#if SaveLoad.save_data.has("biome_layout") and SaveLoad.save_data["biome_layout"].size() > 0:
		#print("data savenya : ", SaveLoad.save_data["biome_layout"] )
		#for i in range(SaveLoad.save_data["biome_layout"].size()):
			#var grid_layouts = Vector2(i,0)
			#var room_data = SaveLoad.save_data["biome_layout"][grid_layouts]["room_name"]
			#var grid_position = SaveLoad.save_data["biome_layout"][grid_layouts]["room_name"]
			#var world_position = Vector2(SaveLoad.save_data["biome_layout"][grid_layouts]["x"], SaveLoad.save_data["biome_layout"][grid_layouts]["y"])
			#grid_layouts.x += 1
			#instance_room(room_data, grid_position, world_position)
		#
	#elif SaveLoad.biome_layout.size() > 0:
		#pass
#
#func save_room_data():
	## Ubah grid_layout ke string
	#var vector_key = str(grid_layout.x) + "," + str(grid_layout.y)
	#
	## Simpan data ke biome_layout
	#SaveLoad.biome_layout[vector_key] = {
		#"room_name": room_name,
		#"grid_position": grid_layout,
		#"x": positioning.x,
		#"y": positioning.y
	#}
	#
	## Simpan biome_layout ke save_data
	#SaveLoad.save_data["biome_layout"] = SaveLoad.biome_layout
	#
	## Simpan ke file
	#SaveLoad.save_game()
	#
	#print("data layout insert: ", SaveLoad.save_data)

#func load_data():
	#if SaveLoad.save_data.has("biome_layout") and SaveLoad.save_data["biome_layout"].size() > 0:
		#print("data savenya: ", SaveLoad.save_data["biome_layout"])
		#
		## Iterasi semua key dalam biome_layout (yang sekarang berupa string)
		#for key in SaveLoad.save_data["biome_layout"].keys():
			## Ubah key (string) kembali menjadi Vector2
			#var coords = key.split(",")
			#var grid_layouts = Vector2(coords[0].to_float(), coords[1].to_float())
			#
			## Akses data dengan key string
			#var room_data = SaveLoad.save_data["biome_layout"][key]["room_name"]
			#var grid_position = SaveLoad.save_data["biome_layout"][key]["grid_position"]
			#var world_position = Vector2(SaveLoad.save_data["biome_layout"][key]["x"], SaveLoad.save_data["biome_layout"][key]["y"])
			#
			## Panggil fungsi instance_room dengan data yang diambil
			#instance_room(room_data, grid_position, world_position)
	#
	#elif SaveLoad.biome_layout.size() > 0:
		#pass  # Tidak ada data tersimpan, tapi ada data di biome_layout
	
	# Fungsi untuk mengubah Vector2 ke String
func vector2_to_string(vec: Vector2) -> String:
	return str(vec.x) + "," + str(vec.y)

# Fungsi untuk mengubah String kembali menjadi Vector2
func string_to_vector2(vec_str: String) -> Vector2:
	var components = vec_str.split(",")
	if components.size() == 2:
		return Vector2(components[0].to_float(), components[1].to_float())
	else:
		return Vector2()  # Kembalikan Vector2 default jika format salah

# Fungsi untuk menyimpan data room
func save_room_data():
	# Ubah grid_layout ke string
	var vector_key = vector2_to_string(grid_layout)
	# Simpan data ke biome_layout
	SaveLoad.biome_layout[vector_key] = {
		"room_name": room_name,
		"grid_position": grid_layout,  # Menyimpan posisi grid asli
		"x": positioning.x,
		"y": positioning.y
	}
	# Simpan biome_layout ke save_data
	SaveLoad.save_data["biome_layout"] = SaveLoad.biome_layout
	# Simpan ke file
	SaveLoad.save_game()
	print("data layout insert: ", SaveLoad.save_data)
	# Fungsi untuk memuat data
	
func load_data():
	if SaveLoad.save_data.has("biome_layout") and SaveLoad.save_data["biome_layout"].size() > 0:
		print("data savenya: ", SaveLoad.save_data)
		# Iterasi semua key dalam biome_layout (yang sekarang berupa string)
		for key in SaveLoad.save_data["biome_layout"].keys():
			# Ubah key (string) kembali menjadi Vector2
			var grid_layouts = string_to_vector2(key)
			# Akses data dengan key string
			var room_data = SaveLoad.save_data["biome_layout"][key]["room_name"]
			var grid_position = SaveLoad.save_data["biome_layout"][key]["grid_position"]
			var world_position = Vector2(SaveLoad.save_data["biome_layout"][key]["x"], SaveLoad.save_data["biome_layout"][key]["y"])
			# Panggil fungsi instance_room dengan data yang diambil
			instance_room(room_data, grid_position, world_position)
	elif SaveLoad.biome_layout.size() > 0:
		pass  # Tidak ada data tersimpan, tapi ada data di biome_layout
