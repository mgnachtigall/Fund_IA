fin = File.open(ARGV[0],"r")
outdir = ARGV[0].split(".").at(0) + "_results"
puts %x[#{"mkdir "+outdir}]
fpout = File.open("./"+outdir+"/path_Hill_Climb.txt","w")
best_value = File.open(ARGV[0].split(".").at(0) + ".best","r").read.to_i


require 'Array'
require 'rubygems'
require 'algorithms'
$print = 0



mh = Containers::MinHeap.new #Heap que armazena os estados com a heurística

lines = fin.read.split("\n")
$numCities = lines[0].split(",").size


$costs = Array.new # Matriz de custos
for j in 0...lines.length
  $costs.push(lines[j].split(",").collect{|i| i.to_i})  #converte o array de str para int
end

for iteration in 0...30 
	total = Time.now

	lista = (0...$numCities).to_a #Cria uma lista com as cidades
	lista.shuffle!				#aleatoriza o estado inicial


	if $print == 1
		puts %x[#{"clear"}]
		p lista
		print "h: ",lista.heuristica,"\n\n"
	end

	$max_iterations = 150000
	# lista.to_file(fpout,lista.heuristica)

	best = Hash.new
	best[:route] = lista
	best[:cost] = lista.heuristica

	candidate = Hash.new

	i=0
	while (i<$max_iterations)
		best[:route].geraFilhos(mh)
		candidate = mh.next	
		
		if candidate[:cost] <= best[:cost]
			best = candidate
			if best[:cost] == best_value
				i = $max_iterations # termina a iteração
			end
		end
		if i%10000 == 0
			puts "i#{iteration}: #{i} > #{best[:cost]}"
		end
		mh.clear
		i+=1
	end

	puts "Tempo: #{(Time.now - total)} best=#{best[:cost]} i: #{i}"
	best[:route].to_file(fpout,best[:cost])
	fpout.print("\n")
end