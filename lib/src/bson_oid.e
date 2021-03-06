note
	description: "[
		Object representing the bson_oid_t structure.
		It contains the 12-byte ObjectId notation defined by the BSON ObjectID specification.
		ObjectId is a 12-byte BSON type, constructed using:
		a 4-byte value representing the seconds since the Unix epoch (in Big Endian)
		a 3-byte machine identifier
		a 2-byte process id (Big Endian), and
		a 3-byte counter (Big Endian), starting with a random value.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_oid_t", "src=http://mongoc.org/libbson/current/bson_oid_t.html", "protocol=uri"
class
	BSON_OID

inherit
	MEMORY_STRUCTURE
		export
			{ANY} managed_pointer
		undefine
			default_create
		redefine
			make_by_pointer,
			managed_pointer
		end

create
	default_create, make_by_pointer, with_string

feature {NONE} -- Creation

	default_create
			-- Initialize an empty OID structure,
		local
			res: INTEGER_32
		do
			make
		end

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
		end

	with_string (a_string: STRING)
		require
			a_string /= Void
		local
			res: INTEGER_32
			c_str: C_STRING
		do
			create c_str.make (a_string)
			make
				-- Keep a reference to `a_string'
			any_data := a_string
			c_bson_oid_init_from_string (item, c_str.item);
		end

feature -- Access

	oid_to_string: STRING_32
		local
			l_ptr: POINTER
			l_mgr: MANAGED_POINTER
			l_memory: MANAGED_POINTER
			l_array: ARRAY [NATURAL_8]
			i: INTEGER
			l_string: C_STRING
		do
			create l_string.make_empty (25)
			c_bson_oid_to_string (item, l_string.item)
			Result := l_string.string
		end

feature -- Delete

	delete
		local
			rc: INTEGER_32
		do
			any_data := Void
		end

feature {ANY}

	managed_pointer: MANAGED_POINTER
			-- <Precursor>

feature {NONE} -- Implementation


	c_bson_oid_init_from_string (a_oid: POINTER; a_str: POINTER)
		external
			"C inline use <bson.h>"
		alias
			"bson_oid_init_from_string ((bson_oid_t *)$a_oid, (const char *)$a_str);"
		end


	c_bson_oid_to_string (a_oid: POINTER; a_str: POINTER)
		external
			"C inline use <bson.h>"
		alias
			"[
				bson_oid_to_string ($a_oid, $a_str);
			]"
		end


	any_data: detachable ANY
			-- Reference to the data feed at creation time using `with_string'

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <bson.h>"
		alias
			"sizeof(bson_oid_t)"
		end




end
