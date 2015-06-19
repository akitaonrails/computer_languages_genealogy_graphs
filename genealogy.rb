require 'erb'
require 'pry'

class Timeline
  attr_accessor :languages, :recent_languages

  def initialize(filter = nil)
    self.languages = {
      "Speedcode" => { year: 1953, author: "John Backus", wikipedia: "https://en.wikipedia.org/wiki/Speedcoding",
        pioneer: [ "interpreted"],
        versions: [],
        influenced: [ "FORTRAN", "ALGOL 58", "C", "PL/I", "MUMPS" ] },
      "FORTRAN" => { year: 1957, author: "John Backus", wikipedia: "https://en.wikipedia.org/wiki/Fortran",
        pioneer: [ "optimizing compiler" ],
        versions: [ ["FORTRAN II", 1958], ["FORTRAN IV", 1961], ["FORTRAN 66", 1966], ["FORTRAN 77", 1977], ["FORTRAN 90", 1992],
                    ["FORTRAN 95", 1997], ["FORTRAN 2003", 2004], ["FORTRAN 2008", 2010], ["FORTRAN 2015", 2015] ],
        influenced: [ "ALGOL 58", "C", "PL/I", "MUMPS", "Julia" ] },
      "ALGOL 58" => { year: 1958, author: "ETH Zürich commitee", wikipedia: "https://en.wikipedia.org/wiki/ALGOL",
        pioneer: ["context-free grammar", "structured programming"],
        versions: [ ["ALGOL 60", 1960], ["ALGOL W", 1966], ["ALGOL 68", 1973] ],
        influenced: [ "C", "CPL", "Pascal", "ADA" ] },
      "ALGOL 60" => { noshow: true,
        versions: [],
        influenced: [ "Simula", "BCPL", "CLU" ] },
      "ALGOL 68" => { noshow: true, wikipedia: "https://en.wikipedia.org/wiki/ALGOL_68",
        versions: [],
        influenced: [ "C", "C++", "ADA", "Python" ] },
      "ALGOL W" => { noshow: true, author: "Niklaus Wirth", wikipedia: "https://en.wikipedia.org/wiki/ALGOL_W",
        versions: [],
        influenced: [ "Pascal" ]},
      "Modula" => { year: 1960, author: "Niklaus Wirth", wikipedia: "https://en.wikipedia.org/wiki/Modula",
        pioneer: [ "module system" ],
        versions: [ ["MODULA-2", 1978 ], ["MODULA-3", 1981], ["PIM 2", 1983], ["PIM 3", 1985], ["PIM 4", 1988], ["ISO MODULA-2", 1996 ] ],
        influenced: [ "Pascal", "Lua", "Go" ] },
      "MODULA-2" => { noshow: true, author: "Niklaus Wirth", wikipedia: "https://en.wikipedia.org/wiki/Modula-2",
        versions: [],
        influenced: [ "Oberon", "ADA", "FORTRAN 90", "Lua" ] },
      "MODULA-3" => { noshow: true, author: "DEC and Olivetti", wikipedia: "https://en.wikipedia.org/wiki/Modula-3",
        versions: [],
        influenced: [ "Java", "Python", "Caml", "C#" ] },
      "Pascal" => { year: 1970, author: "Niklaus Wirth", wikipedia: "https://en.wikipedia.org/wiki/Pascal_(programming_language)",
        pioneer: [ "education" ],
        versions: [ ["Turbo Pascal", 1980], ["Object Pascal", 1986], ["Delphi", 1995], ["Delphi 5", 1999], ["Delphi 7", 2003], ["Delphi XE", 2011], ["Delphi XE4", 2013] ],
        influenced: [ "ADA", "Java", "MODULA-2", "MODULA-3", "Oberon", "Object Pascal", "Go" ] },
      "Object Pascal" => { noshow: true, author: "Anders Hejlsberg", wikipedia: "https://en.wikipedia.org/wiki/Object_Pascal",
        versions: [],
        influenced: [ "C#", "Java" ] },
      "Oberon" => { year: 1986, author: "Niklaus Wirth", wikipedia: "https://en.wikipedia.org/wiki/Oberon_(programming_language)",
        versions: [ ["Oberon-2", 1991], ["Oberon-07", 2007] ],
        influenced: [ "Go" ] },
      "Mesa" => { year: 1970, author: "Xerox Parc", wikipedia: "https://en.wikipedia.org/wiki/Mesa_(programming_language)",
        pioneer: [ "interface/implementation separation", "software exceptions", "thread synchronization", "incremental compilation", "GUI"],
        versions: [],
        influenced: [ "Java", "MODULA-2"] },
      "ABC" => { year: 1980, author: "CWI", wikipedia: "https://en.wikipedia.org/wiki/ABC_(programming_language)",
        pioneer: [ "education" ],
        versions: [],
        influenced: [ "Python"] },
      "SNOBOL" => { year: 1962, author: "AT&T Bell Labs", wikipedia: "https://en.wikipedia.org/wiki/SNOBOL",
        pioneer: [ "patterns as a first-class data type", "operators for pattern concatenation and alternation", "early regular expressions/pattern matching" ],
        versions: [ ["SNOBOL4", 1968] ],
        influenced: [ "Lua" ] },
      "APL" => { year: 1964, author: "Kenneth E. Iverson", wikipedia: "https://en.wikipedia.org/wiki/APL_(programming_language)",
        pioneer: [ "multidimensional array", "mathematical notation" ],
        versions: [],
        influenced: [] },
      "Planner" => { year: 1970, author: "Carl Hewitt", wikipedia: "https://en.wikipedia.org/wiki/Planner_(programming_language)",
        pioneer: [ "logic programming" ],
        versions: [],
        influenced: [] },
      "Prolog" => { year: 1972, author: "Alain Colmerauer", wikipedia: "https://en.wikipedia.org/wiki/Prolog",
        pioneer: [ "logic programming", "theorem proving", "natural language processing", "relations, represented as facts and rules", "running a query over these relations" ],
        versions: [],
        influenced: [ "Erlang" ] },
      "CLU" => { year: 1974, author: "Barbara Liskov", wikipedia: "https://en.wikipedia.org/wiki/CLU_(programming_language)",
        pioneer: [ "early object-oriented programming", "abstract data types", "call-by-sharing", "iterators", "multiple return values (a form of parallel assignment)", "type-safe parameterized types", "type-safe variant types", "classes with constructors and methods, without inheritance" ],
        versions: [],
        influenced: [ "Lua", "ADA", "Ruby", "Swift" ] },
      "AWK" => { year: 1977, author: "Bell Labs", wikipedia: "https://en.wikipedia.org/wiki/AWK",
        pioneer: ["data-driven scripting language", "regular expressions"],
        versions: [ ["GNU AWK", 1988], ["New AWK", 1993] ],
        influenced: [ "Javascript", "Perl", "Lua" ] },
      "FLOW-MATIC" => { year: 1955, author: "Grace Hopper", wikipedia: "https://en.wikipedia.org/wiki/FLOW-MATIC",
        pioneer: ["express operations using English-like statements", "distinctly separate the description of data from the operations on it"],
        versions: [],
        influenced: ["COBOL"] },
      "COBOL" => { year: 1959, author: " Conference on Data Systems Languages (CODASYL)", wikipedia: "https://en.wikipedia.org/wiki/COBOL",
        pioneer: ["designed for business use"],
        versions: [ ["COBOL 60", 1960], ["ANSI COBOL", 1974], ["COBOL 2002", 2002], ["COBOL 2014", 2014] ],
        influenced: [] },
      "ADA" => { year: 1980, author: "MIL-STD", wikipedia: "https://en.wikipedia.org/wiki/Ada_(programming_language)",
        pioneer: [ "strong typing", "modularity mechanisms (packages)", "run-time checking", "parallel processing (tasks, synchronous message passing, protected objects, and nondeterministic select statements)", "exception handling", "generics" ],
        versions: [ ["ADA 83", 1983], ["ANSI ADA", 1987], ["ADA 95", 1995], ["ADA 2012", 2012]],
        influenced: [ "C++", "Eiffel", "Rust", "Ruby", "Java" ] },
      "CPL" => { year: 1963, author: "Christopher Strachey", wikipedia: "https://en.wikipedia.org/wiki/CPL_(programming_language)",
        versions: [],
        influenced: [ "BCPL" ] },
      "PL/I" => { year: 1964, author: "IBM/SHARE", wikipedia: "https://en.wikipedia.org/wiki/PL/I",
        pioneer: [ "replacement for COBOL and FORTRAN", "exception handling", "string handling", "fixed/floating point" ],
        versions: [],
        influenced: [] },
      "BCPL" => { year: 1966, author: "Martin Richards", wikipedia: "https://en.wikipedia.org/wiki/BCPL",
        pioneer: [ "compiler portability", "front/back compilation" ],
        versions: [],
        influenced: [ "B", "C" ] },
      "B" => { year: 1969, author: "Ken Thompson, Dennis Ritchie", wikipedia: "https://en.wikipedia.org/wiki/B_(programming_language)",
        pioneer: [ "arithmetic assignment operators" ],
        versions: [ ["New B", 1972] ],
        influenced: [ "C" ] },
      "C" => { year: 1972, author: "Dennis Ritchie", wikipedia: "https://en.wikipedia.org/wiki/C_(programming_language)",
        pioneer: [ "map efficiently to typical machine instructions", "cross-platform programming" ],
        versions: [ ["ANSI C", 1990], ["C99", 1999], ["C11", 2011] ],
        influenced: [ "AWK", "C++", "C#", "Objective-C", "D", "Go", "Rust", "Java", "Javascript", "Perl", "Python", "PHP/FI" ] },
      "D" => { year: 2001, author: "Walter Bright, Andrei Alexandrescu", wikipedia: "https://en.wikipedia.org/wiki/D_(programming_language)",
        versions: [ ["D2", 2007 ] ],
        influenced: [] },
      "Simula" => { year: 1967, author: "Ole-Johan Dahl, Kristen Nygaard", wikipedia: "https://en.wikipedia.org/wiki/Simula",
        pioneer: [ "object-oriented programming", "inheritance and subclasses", "virtual methods", "coroutines, and discrete event simulation", "garbage collection" ],
        versions: [ ["Simula 67", 1968], ["Simula 87", 1987]],
        influenced: [ "CLU", "Smalltalk", "C with Classes" ] },
      "Smalltalk" => { year: 1972, author: "Alan Kay, Dan Ingalls, Adele Goldberg", wikipedia: "https://en.wikipedia.org/wiki/Smalltalk",
        pioneer: [ "object-oriented software design patterns", "object-oriented programming", "reflection", "classes are first-class objects", "image-based persistence" ],
        versions: [ ["GemStone", 1986], ["Squeak", 1996], ["Pharo", 2008], ["Pharo 4", 2015] ],
        influenced: [ "Groovy", "Objective-C", "Self", "Java", "PHP 5", "Python", "Ruby", "Scala", "Common Lisp" ] },
      "Eiffel" => { year: 1986, author: "Bertrand Meyer", wikipedia: "https://en.wikipedia.org/wiki/Eiffel_(programming_language)",
        pioneer: [ "design by contract", "command-query separation", "uniform-access principle", "single-choice principle", "open-closed principle", "option-operand separation" ],
        versions: [ ["SmartEiffel", 1994], ["LibertyEiffel", 2013] ],
        influenced: [ "ADA 2012", "C#", "D", "Java", "Ruby", "Scala" ] },
      "Pike" => { year: 1994, author: "Fredrik Hübinette", wikipedia: "https://en.wikipedia.org/wiki/Pike_(programming_language)",
        pioneer: ["MUD"],
        versions: [],
        influenced: [ "Prolog" ] },
      "ISWIM" => { year: 1965, author: "Peter J. Landin", wikipedia: "https://en.wikipedia.org/wiki/ISWIM",
        pioneer: ["syntactic sugaring of lambda calculus", "higher order functions", "lexically scoped variables" ],
        versions: [],
        influenced: [ "Miranda", "ML", "Haskell", "Clean"] },
      "MUMPS" => { year: 1966,
        pioneer: [ "ACID (Atomic, Consistent, Isolated, and Durable) transaction processing", "built-in database", "database is accessed through variables, rather than queries or retrievals", "hierarchical database" ],
        versions: [ ["ANSI MUMPS", 1977] ],
        influenced: [ "Caché" ] },
      "Hope" => { year: 1970, author: "Edinburgh University", wikipedia: "https://en.wikipedia.org/wiki/Hope_(programming_language)",
        versions: [],
        influenced: [ "Standard ML"] },
      "occam" => { year: 1983, author: "INMOS", wikipedia: "https://en.wikipedia.org/wiki/Occam_(programming_language)",
        pioneer: ["concurrent programming language", "communication between processes work through named channels"],
        versions: [ ["occam 2", 1987], ["occam 2.1", 1994]],
        influenced: [ "Go" ] },
      "Miranda" => { year: 1985, author: "David Turner", wikipedia: "https://en.wikipedia.org/wiki/Miranda_(programming_language)",
        pioneer: ["lazy, purely functional programming language"],
        versions: [],
        influenced: [ "Haskell", "Clean" ] },
      "Clean" => { year: 1987, author: "Software Technology Research Group of Radboud University Nijmegen", wikipedia: "https://en.wikipedia.org/wiki/Clean_(programming_language)",
        pioneer: ["general-purpose purely functional computer programming language"],
        versions: [],
        influenced: [ "Haskell"] },
      "Caché" => { year: 1996, author: "InterSystems", wikipedia: "https://en.wikipedia.org/wiki/Cach%C3%A9_ObjectScript",
        versions: [],
        influenced: [] },
      "Forth" => { year: 1970, author: "Charles H. Moore", wikipedia: "https://en.wikipedia.org/wiki/Forth_(programming_language)",
        pioneer: ["imperative stack-based", "open firmware"],
        versions: [],
        influenced: [ "REBOL", "Factor" ] },
      "Self" => { year: 1987, author: "David Ungar, Randall Smith", wikipedia: "https://en.wikipedia.org/wiki/Self_(programming_language)",
        pioneer: ["object-oriented programming language based on the concept of prototypes"],
        versions: [ ["Self 4.5", 2014] ],
        influenced: [ "Javascript", "Lua", "REBOL", "Factor" ] },
      "Julia" => { year: 2012, author: "Jeff Bezanson, Stefan Karpinski, Viral B. Shah, Alan Edelman", wikipedia: "https://en.wikipedia.org/wiki/Julia_(programming_language)",
        pioneer: ["high-performance numerical and scientific computing"],
        versions: [ ["Julia 0.3.9", 2015] ],
        influenced: [] },
      "ML" => { year: 1973, author: "Robin Milner/University of Edinburgh", wikipedia: "https://en.wikipedia.org/wiki/ML_(programming_language)",
        pioneer: ["Hindley–Milner type inference algorithm"],
        versions: [],
        influenced: [ "Haskell", "C++", "F#", "Clojure", "Erlang", "Scala", "Standard ML" ] },
      "Standard ML" => { year: 1990, author: "Logic for Computable Functions (LCF)", wikipedia: "https://en.wikipedia.org/wiki/Standard_ML",
        versions: [],
        influenced: [ "OCaml", "Rust" ] },
      "Caml" => { year: 1985, author: "INRIA", wikipedia: "https://en.wikipedia.org/wiki/Caml",
        versions: [ ["OCaml", 1996] ],
        influenced: [ "F#"] },
      "OCaml" => { noshow: true, author: "INRIA", wikipedia: "https://en.wikipedia.org/wiki/OCaml",
        pioneer: ["type systems and type-inferring compilers", "unifies functional, imperative, and object-oriented programming under an ML-like type system"],
        versions: [],
        influenced: [ "Scala", "F#", "Rust" ] },
      "Lisp" => { year: 1958, author: "John McCarthy", wikipedia: "https://en.wikipedia.org/wiki/Lisp_(programming_language)",
        pioneer: [ "tree data structures", "automatic storage management", "dynamic typing", "conditionals", "higher-order functions", "recursion", "self-hosting compiler", "S-expression language" ],
        versions: [],
        influenced: [ "Scheme", "CLU", "Forth", "Haskell", "Lua", "ML", "Python", "REBOL", "Ruby", "Smalltalk", "Factor" ] },
      "Common Lisp" => { year: 1984, author: "Guy L. Steele", wikipedia: "https://en.wikipedia.org/wiki/Common_Lisp",
        pioneer: [ "combination of procedural, functional, and object-oriented programming" ],
        versions: [],
        influenced: [ "Clojure", "Julia", "Dylan"] },
      "Scheme" => { year: 1975, author: "Apple Computer", wikipedia: "https://en.wikipedia.org/wiki/Dylan_(programming_language)",
        pioneer: [ "Scheme + Common Lisp + Business Use/ALGOL-like syntax" ],
        versions: [ ["Scheme R5RS", 1998], ["Scheme R7RS", 2007]],
        influenced: [ "Lua", "Clojure", "Haskell", "Javascript", "Ruby", "Scala" ] },
      "Dylan" => { year: 1992, author: "Apple Computer", wikipedia: "https://en.wikipedia.org/wiki/Dylan_(programming_language)",
        pioneer: ["dynamic language well-suited for developing commercial software"],
        versions: [ ["Dylan 2014.1", 2014] ],
        influenced: [ "Python", "Ruby" ] },
      "Clojure" => { year: 2007, author: "Rich Hickey", wikipedia: "https://en.wikipedia.org/wiki/Clojure",
        versions: [ ["Clojure 1.6", 2014] ],
        influenced: [ "Elixir" ] },
      "Haskell" => { year: 1990, author: "Functional Programming Languages and Computer Architecture (FPCA '87) Committee", wikipedia: "https://en.wikipedia.org/wiki/Haskell_(programming_language)",
        versions: [ ["Haskell 98", 1997], ["Haskell Prime", 2006], ["Haskell 2010", 2010] ],
        influenced: [ "C#", "F#", "Clojure", "Python", "Scala", "Swift" ] },
      "F#" => { year: 2005, author: "Don Syme/Microsoft Research", wikipedia: "https://en.wikipedia.org/wiki/F_Sharp_(programming_language)",
        versions: [ ["F# 2.0", 2010], ["F# 3.0", 2012], ["F# 3.1.1", 2014]],
        influenced: [] },
      "REBOL" => { year: 1997, author: "Carl Sassenrath", wikipedia: "https://en.wikipedia.org/wiki/Rebol",
        pioneer: ["introduces the concept of dialecting: small, optimized, domain-specific languages for code and data", "domain specific languages"],
        versions: [ ["REBOL 2", 1999], ["REBOL/Command", 2001], ["REBOL/View", 2002], ["REBOL/SDK", 2003], ["REBOL 3", 2008]],
        influenced: [] },
      "C with Classes" => { year: 1979, author: "Bjarne Stroustrup",
        versions: [],
        influenced: [ "C++" ] },
      "C++" => { year: 1983, author: "Bjarne Stroustrup", wikipedia: "https://en.wikipedia.org/wiki/C++",
        pioneer: ["enhance the C language with Simula-like features", "influences:  ALGOL 68, Ada, CLU and ML"],
        versions: [ ["C++ 0x", 2011], ["C++ 1y", 2014] ],
        influenced: [ "PHP/FI", "Perl", "Lua", "Pike", "ADA 95", "Java", "D", "C99" ] },
      "C#" => { year: 2000, author: "Anders Hejlsberg/Microsoft", wikipedia: "https://en.wikipedia.org/wiki/C_Sharp_(programming_language)",
        versions: [ ["C# 2", 2005], ["C# 3", 2007], ["C# 4", 2010], ["C# 5", 2013]],
        influenced: [ "Hack", "D", "Swift" ] },
      "Objective-C" => { year: 1983, author: "Brad Cox and Tom Love", wikipedia: "https://en.wikipedia.org/wiki/Objective-C",
        pioneer: ["Smalltalk-style messaging to the C programming language"],
        versions: [ ["GNU Objective-C", 1992], ["Objective-C 2.0", 2006] ],
        influenced: [ "Groovy", "Java", "Swift" ] },
      "Swift" => { year: 2014, author: "Chris Lattner/Apple", wikipedia: "https://en.wikipedia.org/wiki/Swift_(programming_language)",
        highlight: "orange",
        versions: [ ["Swift 1.2", 2015] ],
        influenced: [] },
      "Erlang" => { year: 1986, author: "Joe Armstrong, Robert Virding and Mike Williams", wikipedia: "https://en.wikipedia.org/wiki/Erlang_(programming_language)",
        pioneer: ["support distributed, fault-tolerant, soft-real-time, non-stop applications, hot swapping"],
        versions: [ ["Erlang 17.5", 2015] ],
        influenced: [ "F#", "Clojure", "Rust", "Scala", "Elixir" ] },
      "Elixir" => { year: 2012, author: "José Valim", wikipedia: "https://en.wikipedia.org/wiki/Elixir_(programming_language)",
        versions: [ ["Elixir 1.0", 2014]],
        influenced: [] },
      "Go" => { year: 2007, author: "Robert Griesemer, Rob Pike, Ken Thompson/Google", wikipedia: "https://en.wikipedia.org/wiki/Go_(programming_language)",
        highlight: "black",
        versions: [ ["Go 1.0", 2012], ["Go 1.4", 2015] ],
        influenced: [] },
      "Javascript" => { year: 1995, author: "Brendan Eich", wikipedia: "https://en.wikipedia.org/wiki/JavaScript",
        highlight: "grey",
        versions: [ ["Javascript ES1", 1997], ["Javascript ES3", 1999], ["Javascript ES5.1", 2011], ["Javascript ES6", 2014] ],
        influenced: [] },
      "Rust" => { year: 2011, author: "Graydon Hoare, then Rust Project Developers", wikipedia: "https://en.wikipedia.org/wiki/Rust_(programming_language)",
        pioneer: ["safe, concurrent, practical language", "supporting pure-functional, concurrent-actor, imperative-procedural, and object-oriented styles"],
        versions: [ ["Rust 1.0", 2015]],
        influenced: ["Swift"] },
      "Lua" => { year: 1993, author: "Roberto Ierusalimschy, Waldemar Celes, Luiz Henrique de Figueiredo", wikipedia: "https://en.wikipedia.org/wiki/Lua_(programming_language)",
        pioneer: ["lightweight multi-paradigm programming language designed as a scripting language with extensible semantics as a primary goal"],
        versions: [],
        influenced: [ "Julia", "Javascript" ] },
      "Scala" => { year: 2003, author: "Martin Odersky", wikipedia: "https://en.wikipedia.org/wiki/Scala_(programming_language)",
        versions: [ ["Scala 2.0", 2006], ["Scala 2.11.6", 2015] ],
        influenced: [] },
      "Factor" => { year: 2003, author: "Slava Pestov", wikipedia: "https://en.wikipedia.org/wiki/Factor_(programming_language)",
        pioneer: ["stack-oriented programming language", "image-based"],
        versions: [],
        influenced: [] },
      "Java" => { year: 1995, author: "James Gosling/Sun Microsystems", wikipedia: "https://en.wikipedia.org/wiki/Java_(programming_language)",
        highlight: "purple",
        pioneer: ["general-purpose computer programming language that is concurrent, class-based, object-oriented, and specifically designed to have as few implementation dependencies as possible"],
        versions: [ ["J2SE 5", 2005]],
        influenced: [ "ADA 2005", "C#", "Clojure", "D", "Javascript", "Scala", "PHP/FI", "Groovy", "Hack" ] },
      "Perl" => { year: 1987, author: "Larry Wall", wikipedia: "https://en.wikipedia.org/wiki/Perl",
        pioneer: ["high-level, general-purpose, interpreted, dynamic programming languages"],
        versions: [ ["Perl 5", 1993], ["Perl 5.6", 2000], ["Perl 5.8", 2002], ["Perl 5.10", 2007], ["Perl 5.20", 2014]],
        influenced: [ "Groovy", "Python", "PHP/FI", "Javascript", "Julia" ] },
      "Python" => { year: 1991, author: "Guido van Rossum", wikipedia: "https://en.wikipedia.org/wiki/Python_(programming_language)",
        highlight: "yellow",
        pioneer: ["intended to be a highly readable language"],
        versions: [ ["Python 2", 2000], ["Python 3", 2008]],
        influenced: [ "D", "F#", "Go", "Groovy", "Javascript", "Julia", "Ruby", "Swift" ] },
      "Python 2" => { noshow: true,
        versions: [],
        influenced: [ "Groovy" ] },
      "PHP/FI" => { year: 1995, author: "Rasmus Lerdorf/The PHP Group", wikipedia: "https://en.wikipedia.org/wiki/PHP",
        highlight: "blue",
        pioneer: ["server-side scripting language"],
        versions: [ ["PHP 3", 1997], ["PHP 4", 2000], ["PHP 5", 2004], ["PHP 5.6.10", 2015]],
        influenced: [] },
      "PHP 5" => { noshow: true,
        versions: [],
        influenced: [ "Hack" ] },
      "Hack" => { year: 2014, author: "Facebook", wikipedia: "https://en.wikipedia.org/wiki/Hack_(programming_language)",
        versions: [],
        influenced: [] },
      "Ruby" => { year: 1996, author: "Yukihiro Matsumoto", wikipedia: "https://en.wikipedia.org/wiki/Ruby_(programming_language)",
        highlight: "red",
        pioneer: ["dynamic, reflective, object-oriented, general-purpose programming language"],
        versions: [ ["Ruby 1.2", 1998], ["Ruby 1.4", 1999], ["Ruby 1.6", 2000], ["Ruby 1.8", 2003], ["Ruby 1.9", 2007], ["Ruby 2.1", 2013], ["Ruby 2.2", 2014]],
        influenced: [ "Groovy", "Clojure", "Elixir", "Julia", "Swift" ] },
      "Groovy" => { year: 2007,  author: "James Strachan", wikipedia: "https://en.wikipedia.org/wiki/Groovy_(programming_language)",
        versions: [ ["Groovy 2.0", 2012], ["Groovy 2.4.3", 2015] ],
        influenced: [ ] }
      }

      self.recent_languages = ["C# 5", "C++ 1y", "Swift 1.2", "C11", "Perl 5.20", "ADA 2012", "Delphi XE4", "COBOL 2014", "FORTRAN 2015", "Rust 1.0", "Elixir 1.0", "Erlang 17.5", "Javascript ES6", "Go 1.0", "Self 4.5", "Julia", "Haskell 2010", "F# 3.1.1"]
      #self.ancestors = ["Speedcode", "ALGOL 58", "FLOW-MATIC", "LISP"]

      filter_ancestors(filter)
  end

  def escape_list(list, separator = "; ")
    list.map { |word| "\"#{word}\"" }.join(separator)
  end

  def filter(main_list, list)
    list.select { |word| main_list.include?(word) }
  end

  def languages_filtered
    @languages_filtered ||= languages.reject { |key| languages[key][:noshow] }
  end

  def recent_versions(year = 2014)
    languages_filtered.keys.inject([]) do |acc, key|
      acc += languages_filtered[key][:versions].select do |version|
        version.last > year
      end.map(&:first)
    end
  end

  def all_languages
    languages_filtered.
      inject([]) do |acc, (key, value)|
        acc += value[:versions].map(&:first) unless value[:versions].empty?
        acc += value[:influenced]
      end
  end

  def ancestors
    languages_filtered.keys - all_languages
  end

  def grouped_by_year(versions = true)
    languages_filtered.keys.inject([]) do |acc, key|
      acc += [[key, languages_filtered[key][:year]]] +
        ( versions ? languages_filtered[key][:versions] : [] )
    end.group_by { |a| a.last }
  end

  def formatted_main_rank_groups(versions = true)
    versions = grouped_by_year(versions)
    groups = (1955..2015).step(5).map do |year|
      {
          year: year,
          languages: versions.keys.
            select     { |y| y >= (year - 5) && y < year }.
            inject([]) { |acc, y| acc += versions[y].map(&:first) }.flatten
      }
    end
    groups.each { |g| g[:formatted_languages] = escape_list(g[:languages])}
    groups
  end

  def valid_group(list, accumulator)
    [list,
      recent_languages.select { |e| accumulator.include?(e) },
      ancestors.select { |e| accumulator.include?(e) } ]
  end

  def valid_versions(separator = "; ")
    list = languages_filtered.reject { |key| languages_filtered[key][:versions].empty? }
    accumulator = []
    list.each do |key, value|
      accumulator += value[:versions].map(&:first)
      value[:formatted_versions] = escape_list(value[:versions].map(&:first), separator)
    end
    valid_group(list, accumulator)
  end

  def valid_influenced(separator = "; ")
    list = languages_filtered.reject { |key| languages_filtered[key][:influenced].empty? }
    accumulator = []
    list.each do |key, value|
      accumulator += value[:influenced]
      value[:formatted_influenced] = escape_list(value[:influenced], separator)
    end
    valid_group(list, accumulator)
  end

  def render_erb(filename)
    template = ERB.new File.new("genealogy.erb").read, nil, "%"
    File.open("#{filename}.dot", "w+") do |f|
      f.write template.result(binding)
    end

    system "dot -Tpng #{filename}.dot -o #{filename}.png"
  end

  def generate
    @ancestors = ancestors

    @main_ranks_str = formatted_main_rank_groups(true)
    @valid_influenced = []
    @valid_versions, @recent_languages_filtered, ancestors_filtered = valid_versions(" -> ")
    @ancestors_str = escape_list(ancestors_filtered)
    render_erb('genealogy_versions')

    @main_ranks_str = formatted_main_rank_groups(false)
    @valid_versions = []
    @valid_influenced, @recent_languages_filtered, ancestors_filtered = valid_influenced()
    @ancestors_str = escape_list(ancestors_filtered)
    render_erb('genealogy_influenced')
  end

  private
  def filter_ancestors(filter = nil)
    return unless filter
    queue = [language] + languages.keys.select { |key| languages[key][:versions].map(&:first).include?(language) }
    result = []
    while !queue.empty?
      current_language = queue.pop
      found = languages.keys.select { |key| key != current_language && languages[key][:influenced].include?(current_language) }
      queue = found + queue
      result += found
    end
    self.languages = result.inject({}) { |list, key| list.merge(key => languages[key]) }
  end
end
Timeline.new.generate
