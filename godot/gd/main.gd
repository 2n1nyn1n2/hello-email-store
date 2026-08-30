extends Control
class_name Main

const STORE_EMAIL = "orders@myclothingstore.com"

var products = [
	{
		"id": "SHIRT-01",
		"name": "Minimalist Black Tee",
		"price": "$25.00",
		"desc": "100% organic cotton basic tee.",
		"image": "res://images/SHIRT-01.jpeg"
	},
	{
		"id": "HOODIE-02",
		"name": "Heavyweight Fleece Hoodie",
		"price": "$60.00",
		"desc": "Cozy heavyweight fleece for cold days.",
		"image": "res://images/HOODIE-02.jpeg"
	},
	{
		"id": "CAP-03",
		"name": "Classic Dad Cap",
		"price": "$20.00",
		"desc": "Adjustable cotton twill cap with embroidered logo.",
		"image": "res://images/CAP-03.jpeg"
	},
	{
		"id": "JCKT-04",
		"name": "Utility Bomber Jacket",
		"price": "$95.00",
		"desc": "Sleek water-resistant satin finish jacket.",
		"image": "res://images/JCKT-04.jpeg"
	},
	{
		"id": "PANT-05",
		"name": "Relaxed Fit Chinos",
		"price": "$45.00",
		"desc": "Breathable everyday twill trousers.",
		"image": "res://images/PANT-05.jpeg"
	},
	{
		"id": "SOCK-06",
		"name": "Ribbed Crew Socks (3-Pack)",
		"price": "$15.00",
		"desc": "Cushioned athletic combed cotton socks.",
		"image": "res://images/SOCK-06.jpeg"
	},
	{
		"id": "BEAN-07",
		"name": "Merino Wool Beanie",
		"price": "$28.00",
		"desc": "Warm itch-free fine gauge knit beanie.",
		"image": "res://images/BEAN-07.jpeg"
	}
]

var selected_product = null

# UI References
var main_container: VBoxContainer
var catalog_scroll: ScrollContainer
var catalog_view: VBoxContainer
var checkout_view: VBoxContainer
var product_detail_view: Control
var validation_dialog: AcceptDialog

# Product Detail View Elements
var detail_image: TextureRect
var detail_name_label: Label
var detail_price_label: Label
var detail_sku_label: Label
var detail_desc_label: Label
var detail_buy_btn: Button

# Form inputs
var input_name: LineEdit
var input_address: TextEdit
var input_email: LineEdit
var option_payment_type: OptionButton
var input_account_name: LineEdit
var label_order_id: Label


func _ready() -> void:
	setup_window()
	build_ui()
	show_catalog()


func setup_window() -> void:
	custom_minimum_size = Vector2(850, 650)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func build_ui() -> void:
	main_container = VBoxContainer.new()
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_container.add_theme_constant_override("separation", 0)

	var margin = MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 25)
	margin.add_theme_constant_override("margin_bottom", 25)
	margin.add_theme_constant_override("margin_left", 25)
	margin.add_theme_constant_override("margin_right", 25)
	add_child(margin)

	var outer_vbox = VBoxContainer.new()
	outer_vbox.add_theme_constant_override("separation", 20)
	margin.add_child(outer_vbox)

	# Header Section
	var header_vbox = VBoxContainer.new()
	header_vbox.add_theme_constant_override("separation", 5)
	outer_vbox.add_child(header_vbox)

	var title = Label.new()
	title.text = "✦ THE THREAD STORE ✦"
	title.add_theme_font_size_override("font_size", 26)
	header_vbox.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Curated Modern Essentials • Direct Mail Order Catalog (Click any item for full view)"
	subtitle.add_theme_color_override("font_color", Color(0.55, 0.55, 0.6))
	header_vbox.add_child(subtitle)

	var sep = HSeparator.new()
	outer_vbox.add_child(sep)

	# Views Container (Catalog vs Checkout vs Full Screen Product Detail)
	catalog_scroll = ScrollContainer.new()
	catalog_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	catalog_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_vbox.add_child(catalog_scroll)

	catalog_view = VBoxContainer.new()
	catalog_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	catalog_view.add_theme_constant_override("separation", 15)
	catalog_scroll.add_child(catalog_view)

	product_detail_view = build_product_detail_content()
	product_detail_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	product_detail_view.visible = false
	outer_vbox.add_child(product_detail_view)

	checkout_view = VBoxContainer.new()
	checkout_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	checkout_view.add_theme_constant_override("separation", 15)
	checkout_view.visible = false
	outer_vbox.add_child(checkout_view)

	# Validation Popup Dialog
	validation_dialog = AcceptDialog.new()
	validation_dialog.title = "Validation Error"
	validation_dialog.dialog_text = "Please fill in at least your name and email."
	add_child(validation_dialog)

	build_catalog_content()
	build_checkout_content()


func build_catalog_content() -> void:
	var cat_title = Label.new()
	cat_title.text = "Catalog Collection"
	cat_title.add_theme_font_size_override("font_size", 18)
	catalog_view.add_child(cat_title)

	for p in products:
		var panel = PanelContainer.new()
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		panel.custom_minimum_size = Vector2(0, 115)
		panel.mouse_filter = Control.MOUSE_FILTER_STOP
		panel.gui_input.connect(
			func(event: InputEvent):
				if (
					event is InputEventMouseButton
					and event.pressed
					and event.button_index == MOUSE_BUTTON_LEFT
				):
					_on_product_clicked(p)
		)

		var p_margin = MarginContainer.new()
		p_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p_margin.add_theme_constant_override("margin_top", 12)
		p_margin.add_theme_constant_override("margin_bottom", 12)
		p_margin.add_theme_constant_override("margin_left", 12)
		p_margin.add_theme_constant_override("margin_right", 12)
		panel.add_child(p_margin)

		var hb = HBoxContainer.new()
		hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_theme_constant_override("separation", 20)
		p_margin.add_child(hb)

		var tex_rect = TextureRect.new()
		tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tex_rect.custom_minimum_size = Vector2(90, 90)
		tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		if ResourceLoader.exists(p["image"]):
			tex_rect.texture = load(p["image"])

		hb.add_child(tex_rect)

		var desc_vbox = VBoxContainer.new()
		desc_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		desc_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		desc_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		desc_vbox.add_theme_constant_override("separation", 4)

		var name_price_hb = HBoxContainer.new()
		name_price_hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		desc_vbox.add_child(name_price_hb)

		var name_lbl = Label.new()
		name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		name_lbl.text = p["name"]
		name_lbl.add_theme_font_size_override("font_size", 16)
		name_price_hb.add_child(name_lbl)

		var price_lbl = Label.new()
		price_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		price_lbl.text = "   " + p["price"]
		price_lbl.add_theme_color_override("font_color", Color(0.3, 0.8, 0.5))
		price_lbl.add_theme_font_size_override("font_size", 16)
		name_price_hb.add_child(price_lbl)

		var detail_lbl = Label.new()
		detail_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		detail_lbl.text = p["desc"]
		detail_lbl.add_theme_color_override("font_color", Color(0.65, 0.65, 0.65))
		desc_vbox.add_child(detail_lbl)

		var id_lbl = Label.new()
		id_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		id_lbl.text = "SKU: " + p["id"]
		id_lbl.add_theme_font_size_override("font_size", 11)
		id_lbl.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))
		desc_vbox.add_child(id_lbl)

		hb.add_child(desc_vbox)

		var btn_vb = VBoxContainer.new()
		btn_vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn_vb.alignment = BoxContainer.ALIGNMENT_CENTER
		hb.add_child(btn_vb)

		var buy_btn = Button.new()
		buy_btn.text = "   Buy Item   "
		buy_btn.custom_minimum_size = Vector2(110, 42)
		buy_btn.pressed.connect(func(): _on_buy_clicked(p))
		btn_vb.add_child(buy_btn)

		catalog_view.add_child(panel)


func build_product_detail_content() -> Control:
	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", 15)

	var top_bar = HBoxContainer.new()
	container.add_child(top_bar)

	var back_btn = Button.new()
	back_btn.text = "← Back to Catalog"
	back_btn.custom_minimum_size = Vector2(140, 40)
	back_btn.pressed.connect(show_catalog)
	top_bar.add_child(back_btn)

	var content_split = HBoxContainer.new()
	content_split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_split.add_theme_constant_override("separation", 30)
	container.add_child(content_split)

	# Left side: Large Product Image
	detail_image = TextureRect.new()
	detail_image.custom_minimum_size = Vector2(350, 350)
	detail_image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_image.size_flags_vertical = Control.SIZE_EXPAND_FILL
	detail_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	detail_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	content_split.add_child(detail_image)

	# Right side: Product Information & Action
	var info_vbox = VBoxContainer.new()
	info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	info_vbox.add_theme_constant_override("separation", 15)
	content_split.add_child(info_vbox)

	detail_name_label = Label.new()
	detail_name_label.add_theme_font_size_override("font_size", 24)
	info_vbox.add_child(detail_name_label)

	detail_price_label = Label.new()
	detail_price_label.add_theme_font_size_override("font_size", 20)
	detail_price_label.add_theme_color_override("font_color", Color(0.3, 0.8, 0.5))
	info_vbox.add_child(detail_price_label)

	detail_sku_label = Label.new()
	detail_sku_label.add_theme_font_size_override("font_size", 12)
	detail_sku_label.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))
	info_vbox.add_child(detail_sku_label)

	detail_desc_label = Label.new()
	detail_desc_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	info_vbox.add_child(detail_desc_label)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	info_vbox.add_child(spacer)

	detail_buy_btn = Button.new()
	detail_buy_btn.text = "Proceed to Buy Item"
	detail_buy_btn.custom_minimum_size = Vector2(200, 50)
	detail_buy_btn.pressed.connect(
		func():
			if selected_product:
				_on_buy_clicked(selected_product)
	)
	info_vbox.add_child(detail_buy_btn)

	return container


func build_checkout_content() -> void:
	var chk_title = Label.new()
	chk_title.text = "Secure Order Checkout"
	chk_title.add_theme_font_size_override("font_size", 18)
	checkout_view.add_child(chk_title)

	label_order_id = Label.new()
	label_order_id.text = "Unique Payment Identifier: "
	label_order_id.add_theme_color_override("font_color", Color(0.3, 0.85, 1.0))
	checkout_view.add_child(label_order_id)

	var form_scroll = ScrollContainer.new()
	form_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	form_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	checkout_view.add_child(form_scroll)

	var form_grid = GridContainer.new()
	form_grid.columns = 2
	form_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	form_grid.add_theme_constant_override("h_separation", 15)
	form_grid.add_theme_constant_override("v_separation", 12)
	form_scroll.add_child(form_grid)

	# Name
	var lbl_name = Label.new()
	lbl_name.text = "Full Name:"
	form_grid.add_child(lbl_name)
	input_name = LineEdit.new()
	input_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_name.placeholder_text = "Jane Doe"
	form_grid.add_child(input_name)

	# Email
	var lbl_email = Label.new()
	lbl_email.text = "Email Address:"
	form_grid.add_child(lbl_email)
	input_email = LineEdit.new()
	input_email.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_email.placeholder_text = "jane@example.com"
	form_grid.add_child(input_email)

	# Address
	var lbl_addr = Label.new()
	lbl_addr.text = "Shipping Address:"
	form_grid.add_child(lbl_addr)
	input_address = TextEdit.new()
	input_address.custom_minimum_size = Vector2(0, 70)
	input_address.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_address.placeholder_text = "Street, City, Postal Code, Country"
	form_grid.add_child(input_address)

	# Payment Type
	var lbl_pay = Label.new()
	lbl_pay.text = "Payment Type:"
	form_grid.add_child(lbl_pay)
	option_payment_type = OptionButton.new()
	option_payment_type.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	option_payment_type.add_item("PayPal")
	option_payment_type.add_item("Venmo")
	option_payment_type.add_item("Bank Transfer")
	option_payment_type.add_item("Cryptocurrency")
	form_grid.add_child(option_payment_type)

	# Payment Account Name
	var lbl_acc = Label.new()
	lbl_acc.text = "Payment Account / ID:"
	form_grid.add_child(lbl_acc)
	input_account_name = LineEdit.new()
	input_account_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_account_name.placeholder_text = "e.g., @venmohandle or wallet hash"
	form_grid.add_child(input_account_name)

	# Action Buttons
	var hb_actions = HBoxContainer.new()
	hb_actions.add_theme_constant_override("separation", 15)

	var back_btn = Button.new()
	back_btn.text = "← Back to Catalog"
	back_btn.custom_minimum_size = Vector2(140, 40)
	back_btn.pressed.connect(show_catalog)
	hb_actions.add_child(back_btn)

	var submit_btn = Button.new()
	submit_btn.text = "Open Mail App to Complete Order ✉"
	submit_btn.custom_minimum_size = Vector2(250, 40)
	submit_btn.pressed.connect(_on_submit_order)
	hb_actions.add_child(submit_btn)

	checkout_view.add_child(hb_actions)


func show_catalog() -> void:
	catalog_scroll.visible = true
	product_detail_view.visible = false
	checkout_view.visible = false


func _on_product_clicked(product: Dictionary) -> void:
	selected_product = product

	# Populate full-screen product detail view elements
	detail_name_label.text = product["name"]
	detail_price_label.text = product["price"]
	detail_sku_label.text = "SKU: " + product["id"]
	detail_desc_label.text = product["desc"]

	if ResourceLoader.exists(product["image"]):
		detail_image.texture = load(product["image"])
	else:
		detail_image.texture = null

	catalog_scroll.visible = false
	product_detail_view.visible = true
	checkout_view.visible = false


func _on_buy_clicked(product: Dictionary) -> void:
	selected_product = product
	var unique_id = generate_unique_payment_id()
	label_order_id.text = "Unique Payment Identifier: " + unique_id
	catalog_scroll.visible = false
	product_detail_view.visible = false
	checkout_view.visible = true


func generate_unique_payment_id() -> String:
	var time_str = str(Time.get_unix_time_from_system())
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_suffix = str(rng.randi_range(1000, 9999))
	return "ORD-" + time_str + "-" + rand_suffix


func get_order_email_body(
	order_id: String,
	buyer_name: String,
	buyer_email: String,
	buyer_address: String,
	payment_type: String,
	account_name: String
) -> String:
	var file_path = "res://txt/order_template.txt"
	var file = FileAccess.open(file_path, FileAccess.READ)
	var template = file.get_as_text()

	return template.format(
		{
			"prod_name": selected_product["name"],
			"prod_id": selected_product["id"],
			"prod_price": selected_product["price"],
			"name": buyer_name,
			"email": buyer_email,
			"address": buyer_address,
			"order_id": order_id,
			"pay_type": payment_type,
			"acc_name": account_name
		}
	)


func _on_submit_order() -> void:
	var buyer_name = input_name.text.strip_edges()
	var buyer_email = input_email.text.strip_edges()
	var buyer_address = input_address.text.strip_edges()
	var payment_type = option_payment_type.get_item_text(option_payment_type.selected)
	var account_name = input_account_name.text.strip_edges()

	if buyer_name == "" or buyer_email == "":
		validation_dialog.popup_centered()
		return

	var order_id = label_order_id.text.replace("Unique Payment Identifier: ", "").strip_edges()
	var subject = "New Order: %s [%s]" % [selected_product["name"], order_id]

	var body = get_order_email_body(
		order_id, buyer_name, buyer_email, buyer_address, payment_type, account_name
	)

	var mailto_url = (
		"mailto:%s?subject=%s&body=%s" % [STORE_EMAIL, subject.uri_encode(), body.uri_encode()]
	)

	OS.shell_open(mailto_url)
