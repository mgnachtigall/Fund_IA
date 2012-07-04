fin = File.open(ARGV[0],"r").read.split("\n")
outdir = ARGV[0].split(".").at(0)
system("mkdir "+outdir)

outfile = outdir+"_hillClimb.txt"
fpout = File.open(outfile,"w")

$max_iterations = 150000
# best_value = File.open(outdir+".best","r").read.to_i


require 'Array'
require 'rubygems'
require 'algorithms'
# fin = File.readlines("tsp225.tsp").collect {|line| line.chomp}
 # index = fin.index(fin.select {|line| line[/NODE_COORD_SECTION/] }.to_s)


mh = Containers::MinHeap.new #Heap with mimimun state and values

#Finds the line with the word "DIMENSION" and delete everything other than the int value
$numCities = fin.select {|line| line[/DIMENSION/] }.to_s.delete("DIMENSION : ").to_i

#Gets index for the coordinate section
index = (fin.index(fin.select {|line| line[/NODE_COORD_SECTION/] }.to_s))+1

$coord = Array.new #Array with city coordenates

for i in index...fin.size-1
	temp = fin[index].split(" ").collect {|value| value.to_f}
	$coord([temp[1],temp[2]])
end


# for iteration in 0...30 #Repeat <n> times for statistical tests
	total = Time.now

	lista = (0...$numCities).to_a #Create a list with all the cities
	lista.shuffle!				#randomize 1st state

	

	best = Hash.new
	best[:route] = lista
	best[:cost] = lista.fitness

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
		# if i%10000 == 0
		# 	puts "i#{iteration}: #{i} > #{best[:cost]}"
		# end
		mh.clear
		i+=1
	end

	puts "Time: #{(Time.now - total)} best=#{best[:cost]} i: #{i}"
	best[:route].to_file(fpout,best[:cost])
	fpout.print("\n")
# end