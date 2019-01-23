class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      resp.write handle_cart
    elsif req.path.match(/add/)
      item_to_add = req.params["q"]
      resp.write handle_add(item_to_add)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
  
  def handle_cart
    if !@@cart.empty?
      return @@cart
    else
      return "Your cart is empty"
    end
  end
  
  def handle_add(item_to_add)
    if @@items.include?(item_to_add)
      @@cart << item_to_add
      return "added #{item_to_add}"
    else
      return "We don't have that item"
    end
  end
end


  describe "/add" do

    it 'Will add an item that is in the @@items list' do
      Application.class_variable_set(:@@items, ["Figs","Oranges"])
      get '/add?item=Figs'
      expect(last_response.body).to include("added Figs")
      expect(Application.class_variable_get(:@@cart)).to include("Figs")
    end

    it 'Will not add an item that is not in the @@items list' do
      Application.class_variable_set(:@@items, ["Figs","Oranges"])
      get '/add?item=Apples'
      expect(last_response.body).to include("We don't have that item")
    end
  end
end