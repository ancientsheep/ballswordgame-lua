module(...,package.seeall);

-- categories + words for each

function new()
	categories = {};

	-- load our categories
	categories[1] = loadCategory("actors_actresses");

	-- load individual category list from local file
	-- need to update this to json data with useful tags such as description, title, etc
	function loadCategory(file)

		print("categories : loadCategory - "..file);

		local category = {};
		local path = system.pathForFile("assets/categories/"..file,system.ResourceDirectory);

		category.title = "Category Title";
		category.table = {};

		-- open and push each line into our cateogry table
		for word in io.lines(path) do
			-- add word to our table for this particular category
			category.table[#category.table] = word;
		end

		return category;
	end

	return categories;
end