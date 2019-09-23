class SnackBox
  SNACK_BOX_DATA = {
    1 => {
      "bone" => {
        "info" => "Phoenician rawhide",
        "tastiness" => 20
      },
      "kibble" => {
        "info" => "Delicately braised hamhocks",
        "tastiness" => 33
      },
      "treat" => {
        "info" => "Chewy dental sticks",
        "tastiness" => 40
      }
    },
    2 => {
      "bone" => {
        "info" => "An old dirty bone",
        "tastiness" => 2
      },
      "kibble" => {
        "info" => "Kale clusters",
        "tastiness" => 1
      },
      "treat" => {
        "info" => "Bacon",
        "tastiness" => 80
      }
    },
    3 => {
      "bone" => {
        "info" => "A steak bone",
        "tastiness" => 64
      },
      "kibble" => {
        "info" => "Sweet Potato nibbles",
        "tastiness" => 45
      },
      "treat" => {
        "info" => "Chicken bits",
        "tastiness" => 75
      }
    }
  }
  def initialize(data = SNACK_BOX_DATA)
    @data = data
  end

  def get_bone_info(box_id)
    @data[box_id]["bone"]["info"]
  end

  def get_bone_tastiness(box_id)
    @data[box_id]["bone"]["tastiness"]
  end

  def get_kibble_info(box_id)
    @data[box_id]["kibble"]["info"]
  end

  def get_kibble_tastiness(box_id)
    @data[box_id]["kibble"]["tastiness"]
  end

  def get_treat_info(box_id)
    @data[box_id]["treat"]["info"]
  end

  def get_treat_tastiness(box_id)
    @data[box_id]["treat"]["tastiness"]
  end
end

class CorgiSnacks

  def initialize(snack_box, box_id)
    @snack_box = snack_box
    @box_id = box_id
  end

  def bone
    info = @snack_box.get_bone_info(@box_id)
    tastiness = @snack_box.get_bone_tastiness(@box_id)
    result = "Bone: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

  def kibble
    info = @snack_box.get_kibble_info(@box_id)
    tastiness = @snack_box.get_kibble_tastiness(@box_id)
    result = "Kibble: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

  def treat
    info = @snack_box.get_treat_info(@box_id)
    tastiness = @snack_box.get_treat_tastiness(@box_id)
    result = "Treat: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

end


class MetaCorgiSnacks
  def initialize(snack_box, box_id)
    @snack_box = snack_box
    @box_id = box_id
    snack_box.methods.grep(/^get_(.*)_info$/) { MetaCorgiSnacks.define_snack $1 }
  end

  # def method_missing(name, *args)
  #   # Your code goes here...
  #   info = @snack_box.send("get_#{name}_info", @box_id)
  #   tastiness = @snack_box.send("get_#{name}_tastiness", @box_id)
  #   name = "#{name.to_s.split('_').map(&:capitalize).join(' ')}"
  #   result = "#{name}: #{info}: #{tastiness} "
  #   tastiness > 30 ? "* #{result}" : result
  # end


  def self.define_snack(name)
    # Your code goes here...
    define_method(name) do
      info = @snack_box.send("get_#{name}_info", @box_id)
      tastiness = @snack_box.send("get_#{name}_tastiness", @box_id)
      name = "#{name.to_s.split('_').map(&:capitalize).join(' ')}"
      result = "#{name}: #{info}: #{tastiness} "
      tastiness > 30 ? "* #{result}" : result
    end
  end
end

Check out the SnackBoxs instance methods to get snack info and tastiness levels:

pry(main)> load 'meta_corgis.rb'
pry(main)> snack_box = SnackBox.new
pry(main)> snack_box.get_bone_info(1) # => "Phoenician rawhide"
pry(main)> snack_box.get_kibble_tastiness(3) # => 45
Then test out the CorgiSnacks class:

pry(main)> snacks = CorgiSnacks.new(snack_box, 1)
pry(main)> snacks.bone # => "Bone: Phoenician rawhide: 20"
pry(main)> snacks.kibble # => "* Kibble: Delicately braised hamhocks: 33"

//////////////////////////////////////////
pry(main)> load 'meta_corgis.rb'
pry(main)> snack_box = SnackBox.new
pry(main)> meta_snacks = MetaCorgiSnacks.new(snack_box, 1)
pry(main)> meta_snacks.bone # => "Bone: Phoenician rawhide: 20 "
pry(main)> meta_snacks.kibble # => "* Kibble: Delicately braised hamhocks: 33"

pry(main)> load 'meta_corgis.rb'
pry(main)> MetaCorgiSnacks.define_snack("bone")
pry(main)> snack_box = SnackBox.new
pry(main)> meta_snacks = MetaCorgiSnacks.new(snack_box, 1)
pry(main)> meta_snacks.bone # => "Bone: Phoenician rawhide: 20 "
pry(main)> meta_snacks.kibble # => "NoMethodError: undefined method `kibble'...""


Almost there! Now we just need to automatically call CorgiSnacks::define_snack for each snack upon initialization.

How do we know what the different snacks are?
One way to tell is to call #methods on our @snack_box.
This will give us back an array of all the methods defined on that object.
Then we can match the ones we care about using grep.
If we pass grep the argument /^get_(.*)_info$/, it will match any methods that are some variation of get_{snack}_info and "capture" the snack name - the (.*) tells it to capture any number of characters that come between get_ and _info.
We can then use $1 to get back the matching snack name that was captured.
So we can pass the block { MetaCorgiSnacks.define_snack $1 } to our grep call, and it will call ::define_snack with each snack name.
You should call something like this in the initialize method:

snack_box.methods.grep(/^get_(.*)_info$/) { MetaCorgiSnacks.define_snack $1 }
This should work as before again, without having to call MetaCorgiSnacks.define_snack("bone") first!

pry(main)> load 'meta_corgis.rb'
pry(main)> snack_box = SnackBox.new
pry(main)> meta_snacks = MetaCorgiSnacks.new(snack_box, 1)
pry(main)> meta_snacks.bone # => "Bone: Phoenician rawhide: 20 "
pry(main)> meta_snacks.kibble # => "* Kibble: Delicately braised hamhocks: 33 "
pry(main)> meta_snacks.treat # => "Treat: Chewy dental sticks: 40 "