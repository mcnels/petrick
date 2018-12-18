#!/usr/bin/env ruby
require 'bitset'

def power(a,b)
  result=a**b
  result.to_i
  return result
end

puts "enter number of variables:"
vars = gets
# size = power(2, vars.to_i)
pimp = Array.new
pimptable = Array.new
reduced = Array.new
#pimpmat = Array.new
letras = ("A".."Z").to_a
# pimp = Array.new(size){Array.new(size)}

puts "enter minterms:"
minterms = gets
minterms.split(' ').each { |x| pimp.push(x.to_i) }

# bin = Array.new
# pimp.each do |dec|
#   bin.push(Bitset.from_s(dec.to_s(2)))
#   # bin.push(dec.to_s(2))
# end

# puts bin

# STEP 1
pimp.each do |d|
  binstring = Bitset.from_s(d.to_s(2))
  # puts binstring.size
  binvalue = d.to_s(2)
  while binstring.size < vars.to_i
    # break if binstring.size >= vars
    # puts binvalue
    binvalue = '0'+binvalue
    binstring = Bitset.from_s(binvalue)
  end

  letra = ""

  (0..(vars.to_i)-1).each do |v|
    if binvalue[v].to_i == 1
      letra = letra + letras[v]
    else
      letra = letra + letras[v]+ "'"
    end
  end

  pimptable.push(:letters => letra, :imp => 'm'+d.to_s, :bin => binvalue, :num1s => binstring.cardinality)
end

puts "----------------------"
puts "Prime implicant table:"
puts "----------------------"
puts pimptable

x = 0
# STEP 2
 pimptable.each do |pt|
   (1..(pimp.count)-1).each do |r|
      newbin = ""
      if pt[:num1s] == (pimptable[r][:num1s] - 1)
        # if (pt[:bin].to_s(2) ^ pimptable[r][:bin].to_s(2)).to_s(2)
        comp = Bitset.from_s(pt[:bin]) ^ Bitset.from_s(pimptable[r][:bin])

        if comp.cardinality == 1
          x += 1
          #puts comp
          ind = comp.to_s.index('1')

          newbin = pt[:bin].dup
          newbin[ind] = '-'

          letra = ""
          (0..(vars.to_i)-1).each do |v|
            if newbin[v].to_i == 1
              letra = letra + letras[v]
            elsif newbin[v] == "-"
              letra = letra
            else
              letra = letra + letras[v]+ "'"
            end
          end

          lbl = "P"+x.to_s

          reduced.push(:label => lbl,:letters => letra, :imp => pt[:imp]+","+pimptable[r][:imp], :bin => newbin, :num1s => Bitset.from_s(newbin).cardinality)
        end
      end

    end
  end

puts "---------"
puts "Reduction"
puts "---------"
puts reduced


# STEP 3
pimpmat = Array.new(pimp.count + 1){Array.new(pimp.count + 1)}


i = 1
reduced.each do |red|
  j = 1
  pimp.each do |pp|
    pimpmat[i][0] = red[:label]
    pimpmat[0][j] = pp

    if red[:imp].include? pp.to_s
      pimpmat[i][j] = 1
    else
      pimpmat[i][j] = 0
    end
    j += 1
  end
  i += 1
end

puts "------"
puts "Matrix"
puts "------"
pimpmat.each { |x|
  puts x.join(" ")
}

# STEP 4 : Petrick
result = ""

# (1..pimpmat.count).each do |row|
#   (1..pimpmat.count).each do |col|
#     if pimpmat[row][col] == 1
#       result = pimpmat[row][0].to_s+""
#     end
#   end
# end

npimpmat = pimpmat.transpose
# npimpmat.each { |x|
#   puts x.join(" ")
# }

# puts result
k = 1
npimpmat[1..-1].each do |row|
  l = 1
  result = result + "("
  row[1..-1].each do |col|

    if col == 1
      # puts npimpmat[0][l]
      result = result+npimpmat[0][l].to_s + "+"
    end
    l += 1
  end
  # Remove last '+'
  if result[-1] == '+'
    result = result.chop
  end
  result = result + ")"
  k += 1
end

puts "--------------------"
puts "Simplification steps"
puts "--------------------"
puts "F = " +result

# Split result in groups of '(..)' expressions
exp = Array.new
result.split(')(').each { |x| exp.push(x.to_s) }
if exp[-1].include? ")"
  exp[-1] = exp[-1].chop
end
if exp[0].include? "("
  exp[0] = exp[0].reverse.chop.reverse
end
puts exp

Rules:
1. X + XY = X
2. XX = X
3. X + X = X
4. (X + Y)(X + Z) = X + YZ


iterate over exp array and apply Rules
exp.each do |exp|
  sides = Array.new
  exp.split('+') { |x| sides.push(x.to_s) }
  curlhs = sides[0]
  currhs = sides[1]

  if curlhs.include? currhs || currhs.include? curlhs #rule 1

  end

  if curlhs == currhs #rule 3

  end

  exp[1..-1].each do |nxt|
    nsides = Array.new
    exp.split('+') { |x| sides.push(x.to_s) }
    nlhs = nsides[0]
    nrhs = nsides[1]

    if curlhs == nlhs
      if currhs == nrhs # rule 4

      else # rule 2

      end
    end

  end
end

# Put result back together





# result = ""
