origin = 4
params = {:threshold=>3, :off=>1}

puts params[:threshold]
puts params[:off]
 
#script = 'params[:threshold]' 
script = 'origin >= params[:threshold]? params[:off] : 0'

puts eval(script)
  
  