## Computer Languages Genealogy

![Language Versions through Time](output/genealogy_versions.png)

![Language Influences through Time](output/genealogy_influenced.png)

If you want to tweak and generate your own versions install the 'pry' gem (or comment it out from the ruby script)

Just run `ruby genealogy.rb` and look into the `output` directory for the generated files.

You will also need graphviz installed.

The idea is not to be a 100% complete timeline but to have at the very least the languages that were instrumental through the history of the computer.

Wikipedia was used for 90% of the graph information of which language influenced which and some extra Googling to make sure the main relations are correct.

Author: Fabio Akita (C) [Akitaonrails.com](http://akitaonrails.com)

### Wish List/TO DO

- reorganize the main class to be more readable (it's quite messy at this point).
- create a separated bin file to execute the `generate` method instead of having it lost at the end of the file.
- have a way to select one main language and see only the previous languages that influenced it.
- make some more cosmetic changes to make it more appealing (the colors are not great, the node styles are not great)
