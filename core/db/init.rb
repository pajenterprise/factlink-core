# coding: utf-8

LoadDsl.load do

  user "merijn", "merijn@gmail.com", "123hoi", "merijn481", "Merijn", "Terheggen"
  user "tomdev", "tom@factlink.com", "123hoi", "tomdev", "Tom", "de Vries"
  user "remon", "remon@factlink.com", "123hoi", "R51", "Remon", "Oldenbeuving"
  user "mark", "mark@factlink.com", "123hoi", "markijbema", "Mark", "IJbema"
  user "jjoos", "deelstra@factlink.com", "123hoi", "jjoos", "Jan", "Deelstra"
  user "jens", "jens@factlink.com", "123hoi", "jens", "Jens", "Kanis"
  user "martijn", "martijn@factlink.com", "123hoi", "martijn", "Martijn", "Russchen"
  user "eamon", "eamon@factlink.com", "123hoi", "eamon", "Eamon", "Nerbonne"

  user "tomdev"
    fact "Oil is still detrimental to the environment,", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm"
      believers "merijn","tomdev","jjoos"
      disbelievers "remon","mark"
      doubters "martijn"
    fact "Molecules that are not accessible to microbes persist and could have toxic effects", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm"
      believers "merijn","tomdev"
      disbelievers "remon","mark","jjoos"
    fact "Oil that is consumed by microbes \"is being converted to carbon dioxide that still gets into the atmosphere.\"", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm"
      believers "merijn","jjoos"
      disbelievers "tomdev","mark"
      doubters "martijn"
    fact "The dynamic microbial community of the Gulf of Mexico supported remarkable rates of oil respiration, despite a dearth of dissolved nutrients,", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm"
      believers "tomdev","mark"
      disbelievers "merijn","jjoos"
      doubters "martijn"
    fact "Microbes had the metabolic potential to break down a large portion of hydrocarbons and keep up with the flow rate from the wellhead", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm"
      disbelievers "jjoos"
      doubters "tomdev"
    fact "the molecules that are not accessible to microbes persist and could have toxic effects", "http://example.org/"
      believers "jjoos"
      disbelievers "tomdev"
    fact "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant.", "http://en.wikipedia.org/wiki/Tim_Cook"
      believers "tomdev"
      disbelievers "jjoos"
    fact "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections", "http://www.sciencedaily.com/"
      believers "tomdev","jjoos"

  user "jjoos"
    fact "The plant Arabidopsis thaliana is found throughout the entire northern hemisphere", "http://www.sciencedaily.com/"
      believers "jjoos"
    fact "When viruses infect a cell, they take over its cellular machinery for their own purpose -- that is, creating more copies of the virus.", "http://www.sciencedaily.com/releases/2011/08/110826134012.htm"
      believers "jjoos"
    fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.", "http://slashdot.org/"
      believers "jjoos"
    fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.  ", "http://localhost:3000/"
      doubters "jjoos"
    fact "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating", "http://www.sciencedaily.com/"
      believers "jjoos"
    fact " New Depiction of Light Could Boost Telecommunications Channels Physicists have presented a new way to map spiraling light that could help harness untapped data channels in optical fibers. Increased bandwidth would ease the burden on fiber-optic telecommunications networks taxed ...  > full story more on: Optics; Graphene; Inorganic Chemistry; Chemistry; Physics; Computer Modeling ", "http://www.sciencedaily.com/"
      disbelievers "jjoos"
    fact " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System ", "http://www.sciencedaily.com/"
      disbelievers "jjoos"
    fact "De veiligheid van liften in Nederland is in gevaar doordat vier van de zes bedrijven die liften mogen keuren niet onafhankelijk zijn van hun opdrachtgevers. ", "http://www.nrc.nl/nieuws/2011/08/29/veiligheid-liften-in-gevaar-omdat-keuringen-niet-onafhankelijk-zijn/"
      doubters "jjoos"
    fact "Stanford microsurgeons have used a poloxamer gel and bioadhesive, rather than a needle and thread, to join together blood vessels", "http://slashdot.org/"
      disbelievers "jjoos"
    fact "\"On earth, nuclear reactors are under attack because of concerns over damage caused by natural disasters. In space, however, nuclear technology may get a new lease on life.", "http://slashdot.org/"
      believers "jjoos"

  user "tomdev"
    fact_relation "the molecules that are not accessible to microbes persist and could have toxic effects", :supporting, "Oil is still detrimental to the environment,"
      believers "merijn","tomdev","jjoos"
      disbelievers "remon","martijn"
    fact_relation "Oil that is consumed by microbes \"is being converted to carbon dioxide that still gets into the atmosphere.\"", :supporting, "Oil is still detrimental to the environment,"
      doubters "tomdev"
    fact_relation "Microbes had the metabolic potential to break down a large portion of hydrocarbons and keep up with the flow rate from the wellhead", :weakening, "Oil is still detrimental to the environment,"
      believers "tomdev"
    fact_relation "the molecules that are not accessible to microbes persist and could have toxic effects", :supporting, "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant."
      disbelievers "tomdev"
    fact_relation "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant.", :supporting, "Molecules that are not accessible to microbes persist and could have toxic effects"
      disbelievers "tomdev"
    fact_relation "Microbes had the metabolic potential to break down a large portion of hydrocarbons and keep up with the flow rate from the wellhead", :supporting, "Molecules that are not accessible to microbes persist and could have toxic effects"
      believers "tomdev"
    fact_relation "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant.", :supporting, "the molecules that are not accessible to microbes persist and could have toxic effects"
      disbelievers "tomdev"
    fact_relation "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant.", :supporting, "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections"
      disbelievers "tomdev"

  user "jjoos"
    fact_relation "When viruses infect a cell, they take over its cellular machinery for their own purpose -- that is, creating more copies of the virus.", :supporting, ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million."
      believers "jjoos"
    fact_relation "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections", :weakening, ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million."
      believers "jjoos"
    fact_relation "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating", :supporting, ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million."
      believers "jjoos"
    fact_relation ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.  ", :supporting, "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating"
      believers "jjoos"
    fact_relation " New Depiction of Light Could Boost Telecommunications Channels Physicists have presented a new way to map spiraling light that could help harness untapped data channels in optical fibers. Increased bandwidth would ease the burden on fiber-optic telecommunications networks taxed ...  > full story more on: Optics; Graphene; Inorganic Chemistry; Chemistry; Physics; Computer Modeling ", :supporting, " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System "
      believers "jjoos"
    fact_relation ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.  ", :weakening, " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System "
      believers "jjoos"
    fact_relation ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.", :supporting, " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System "
      believers "jjoos"
    fact_relation "The plant Arabidopsis thaliana is found throughout the entire northern hemisphere", :supporting, " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System "
      believers "jjoos"
    fact_relation "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating", :supporting, " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System "
      believers "jjoos"
    fact_relation "De veiligheid van liften in Nederland is in gevaar doordat vier van de zes bedrijven die liften mogen keuren niet onafhankelijk zijn van hun opdrachtgevers. ", :supporting, "Stanford microsurgeons have used a poloxamer gel and bioadhesive, rather than a needle and thread, to join together blood vessels"
      believers "jjoos"
    fact_relation "Stanford microsurgeons have used a poloxamer gel and bioadhesive, rather than a needle and thread, to join together blood vessels", :weakening, "\"On earth, nuclear reactors are under attack because of concerns over damage caused by natural disasters. In space, however, nuclear technology may get a new lease on life."
      believers "jjoos"
    fact_relation "De veiligheid van liften in Nederland is in gevaar doordat vier van de zes bedrijven die liften mogen keuren niet onafhankelijk zijn van hun opdrachtgevers. ", :supporting, "\"On earth, nuclear reactors are under attack because of concerns over damage caused by natural disasters. In space, however, nuclear technology may get a new lease on life."
      believers "jjoos"
    fact_relation ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.  ", :supporting, "\"On earth, nuclear reactors are under attack because of concerns over damage caused by natural disasters. In space, however, nuclear technology may get a new lease on life."
      believers "jjoos"

  user "tomdev"
    channel "War & Peace"
      add_fact "Oil is still detrimental to the environment,"
      add_fact "Molecules that are not accessible to microbes persist and could have toxic effects"
      add_fact "Oil that is consumed by microbes \"is being converted to carbon dioxide that still gets into the atmosphere.\""
      add_fact "The dynamic microbial community of the Gulf of Mexico supported remarkable rates of oil respiration, despite a dearth of dissolved nutrients,"
      add_fact "Microbes had the metabolic potential to break down a large portion of hydrocarbons and keep up with the flow rate from the wellhead"
      add_fact "the molecules that are not accessible to microbes persist and could have toxic effects"
      sub_channel "jjoos", "War & Peace"
    channel "Oil"
      add_fact "Oil is still detrimental to the environment,"
      add_fact "Molecules that are not accessible to microbes persist and could have toxic effects"
      add_fact "Oil that is consumed by microbes \"is being converted to carbon dioxide that still gets into the atmosphere.\""
      add_fact "The dynamic microbial community of the Gulf of Mexico supported remarkable rates of oil respiration, despite a dearth of dissolved nutrients,"
      add_fact "Microbes had the metabolic potential to break down a large portion of hydrocarbons and keep up with the flow rate from the wellhead"
      add_fact "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections"

  user "jjoos"
    channel "War & Peace"
      add_fact "Molecules that are not accessible to microbes persist and could have toxic effects"
      add_fact "Oil that is consumed by microbes \"is being converted to carbon dioxide that still gets into the atmosphere.\""
      add_fact "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant."
      add_fact "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections"
      add_fact "The plant Arabidopsis thaliana is found throughout the entire northern hemisphere"
      add_fact "When viruses infect a cell, they take over its cellular machinery for their own purpose -- that is, creating more copies of the virus."
      add_fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million."
      add_fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.  "
      add_fact "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating"
      add_fact " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System "
      add_fact "Stanford microsurgeons have used a poloxamer gel and bioadhesive, rather than a needle and thread, to join together blood vessels"
      add_fact "\"On earth, nuclear reactors are under attack because of concerns over damage caused by natural disasters. In space, however, nuclear technology may get a new lease on life."
    channel "Climate Change"
      add_fact "Molecules that are not accessible to microbes persist and could have toxic effects"
      add_fact "Oil that is consumed by microbes \"is being converted to carbon dioxide that still gets into the atmosphere.\""
      add_fact "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant."
      add_fact "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections"
      add_fact "When viruses infect a cell, they take over its cellular machinery for their own purpose -- that is, creating more copies of the virus."
      add_fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million."
      add_fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.  "
      add_fact "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating"
      add_fact " New Depiction of Light Could Boost Telecommunications Channels Physicists have presented a new way to map spiraling light that could help harness untapped data channels in optical fibers. Increased bandwidth would ease the burden on fiber-optic telecommunications networks taxed ...  > full story more on: Optics; Graphene; Inorganic Chemistry; Chemistry; Physics; Computer Modeling "
    channel "The new web"
      add_fact "Microbes had the metabolic potential to break down a large portion of hydrocarbons and keep up with the flow rate from the wellhead"
      add_fact "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant."
      add_fact "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections"
      add_fact "The plant Arabidopsis thaliana is found throughout the entire northern hemisphere"
      add_fact "When viruses infect a cell, they take over its cellular machinery for their own purpose -- that is, creating more copies of the virus."
      add_fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million."
      add_fact "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating"
      add_fact " New Depiction of Light Could Boost Telecommunications Channels Physicists have presented a new way to map spiraling light that could help harness untapped data channels in optical fibers. Increased bandwidth would ease the burden on fiber-optic telecommunications networks taxed ...  > full story more on: Optics; Graphene; Inorganic Chemistry; Chemistry; Physics; Computer Modeling "
end
