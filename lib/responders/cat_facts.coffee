class Responder extends Bitbot.BaseResponder

  # list compiled by Glenda Moore
  # http://user.xmission.com/~emailbox/trivia.htm

  responderName: "Cat Fact"
  responderDesc: "Provides a random cat fact when asked for one."

  commandPrefix: "cat"

  commands:
    fact:
      desc: "Generates a cat fact"
      examples: ["I hate cats.", "cat fact?", "what should I know about cats?"]
      intent: "catfact"

  templates:
    fact: "🐱 CAT FACT {{&response}}"

  responses: [
    "#1002: A cat's brain is more similar to a man's brain than that of a dog."
    "#1003: A cat has more bones than a human; humans have 206, but the cat has 230 (some cites list 245 bones, and state that bones may fuse together as the cat ages)."
    "#1004: Cats have 30 vertebrae (humans have 33 vertebrae during early development; 26 after the sacral and coccygeal regions fuse)"
    "#1005: The cat's clavicle, or collarbone, does not connect with other bones but is buried in the muscles of the shoulder region. This lack of a functioning collarbone allows them to fit through any opening the size of their head."
    "#1006: The cat has 500 skeletal muscles (humans have 650)."
    "#1007: Cats have 32 muscles that control the outer ear (compared to human's 6 muscles each). A cat can rotate its ears independently 180 degrees, and can turn in the direction of sound 10 times faster than those of the best watchdog."
    "#1008: Cats' hearing is much more sensitive than humans and dogs."
    "#1009: Cats' hearing stops at 65 khz (kilohertz); humans' hearing stops at 20 khz."
    "#1010: A cat sees about 6 times better than a human at night, and needs 1/6 the amount of of light that a human does - it has a layer of extra reflecting cells which absorb light."
    "#1011: Recent studies have shown that cats can see blue and green. There is disagreement as to whether they can see red."
    "#1012: A cat's field of vision is about 200 degrees."
    "#1013: Unlike humans, cats do not need to blink their eyes on a regular basis to keep their eyes lubricated."
    "#1014: Blue-eyed, pure white cats are frequently deaf."
    "#1015: It may take as long as 2 weeks for a kitten to be able to hear well.  Their eyes usually open between 7 and 10 days, but sometimes it happens in as little as 2 days."
    "#1016: Cats can judge within 3 inches the precise location of a sound being made 1 yard away."
    "#1017: Cats can be right-pawed or left-pawed."
    "#1018: A cat cannot see directly under its nose."
    "#1019: Almost 10% of a cat's bones are in its tail, and the tail is used to maintain balance."
    "#1020: The domestic cat is the only species able to hold its tail vertically while walking. You can also learn about your cat's present state of mind by observing the posture of his tail."
    "#1021: If a cat is frightened, the hair stands up fairly evenly all over the body; when the cat is threatened or is ready to attack, the hair stands up only in a narrow band along the spine and tail."
    "#1022: A cat has approximately 60 to 80 million olfactory cells (a human has between 5 and 20 million)."
    "#1023: Cats have a special scent organ located in the roof of their mouth, called the Jacobson's organ. It analyzes smells - and is the reason why you will sometimes see your cat \"sneer\" (called the flehmen response or flehming) when they encounter a strong odor."
    "#1024: Cats dislike citrus scent."
    "#1025: A cat has a total of 24 whiskers, 4 rows of whiskers on each side. The upper two rows can move independently of the bottom two rows."
    "#1026: Cats have 30 teeth (12 incisors, 10 premolars, 4 canines, and 4 molars), while dogs have 42. Kittens have baby teeth, which are replaced by permanent teeth around the age of 7 months."
    "#1027: A cat's jaw has only up and down motion; it does not have any lateral, side to side motion, like dogs and humans."
    "#1028: A cat's tongue has tiny barbs on it."
    "#1029: Cats lap liquid from the underside of their tongue, not from the top."
    "#1030: Cats purr at the same frequency as an idling diesel engine, about 26 cycles per second."
    "#1031: Domestic cats purr both when inhaling and when exhaling."
    "#1032: The cat's front paw has 5 toes, but the back paws have 4. Some cats are born with as many as 7 front toes and extra back toes (polydactl)."
    "#1033: Cats walk on their toes."
    "#1034: A domestic cat can sprint at about 31 miles per hour."
    "#1035: A kitten will typically weigh about 3 ounces at birth.  The typical male housecat will weigh between  7 and 9 pounds, slightly less for female housecats."
    "#1036: Cats take between 20-40 breaths per minute."
    "#1037: Normal body temperature for a cat is 102 degrees F."
    "#1038: A cat's normal pulse is 140-240 beats per minute, with an average of 195."
    "#1039: Cat's urine glows under a black light."
    "#1040: Cats lose almost as much fluid in the saliva while grooming themselves as they do through urination."
    "#1041: A cat has two vocal chords, and can make over 100 sounds."
    "#1042: Historical Trivia"
    "#1043: Miacis and Proailurus"
    "#1044: Miacis, the primitive ancestor of cats, was a small, tree-living creature of the late Eocene period, some 45 to 50 million years ago."
    "#1045: Phoenician cargo ships are thought to have brought the first domesticated cats to Europe in about 900 BC."
    "#1046: The first true cats came into existence about 12 million years ago and were the Proailurus."
    "#1047: Experts traditionally thought that the Egyptians were the first to domesticate the cat, some 3,600 years ago.  But recent genetic and archaeological discoveries indicate that cat domestication began in the Fertile Crescent, perhaps around 10,000 years ago, when agriculture was getting under way. (per Scientific American, 6/10/2009)"
    "#1048: Ancient Egyptian family members shaved their eyebrows in mourning when the family cat died."
    "#1049: In Siam, the cat was so revered that one rode in a chariot at the head of a parade celebrating the new king."
    "#1050: The Pilgrims were the first to introduce cats to North America."
    "#1051: The first breeding pair of Siamese cats arrived in England in 1884."
    "#1052: The first formal cat show was held in England in 1871; in America, in 1895."
    "#1053: The Maine Coon cat is America's only natural breed of domestic feline. It is 4 to 5 times larger than the Singapura, the smallest breed of cat."
    "#1054: There are approximately 100 breeds of cat."
    "#1055: The life expectancy of cats has nearly doubled since 1930 - from 8 to 16 years."
    "#1056: Cats have been domesticated for half as long as dogs have been."
    "#1057: Diet, Health, and Behavior"
    "#1058: Cats respond most readily to names that end in an \"ee\" sound."
    "#1059: The female cat reaches sexual maturity within 6 to 10 months; most veterinarians suggest spaying the female at 5 months, before her first heat period. The male cat usually reaches sexual maturity between 9 and 12 months."
    "#1060: Female cats are \"polyestrous,\" which means they may have many heat periods over the course of a year. A heat period lasts about 4 to 7 days if the female is bred; if she is not, the heat period lasts longer and recurs at regular intervals."
    "#1061: A female cat will be pregnant for approximately 9 weeks - between 62 and 65 days from conception to delivery."
    "#1062: Female felines are \"superfecund,\" which means that each of the kittens in her litter can have a different father."
    "#1063: Many cats love having their forehead gently stroked."
    "#1064: If a cat is frightened, put your hand over its eyes and forehead, or let him bury his head in your armpit to help calm him."
    "#1065: A cat will tremble or shiver when it is in extreme pain."
    "#1066: Cats should not be fed tuna exclusively, as it lacks taurine, an essential nutrient required for good feline health."
    "#1067: Purring does not always indicate that a cat is happy and healthy - some cats will purr loudly when they are terrified or in pain."
    "#1068: Not every cat gets \"high\" from catnip. If the cat doesn't have a specific gene, it won't react (about 20% do not have the gene). Catnip is non-addictive."
    "#1069: Cats must have fat in their diet because they can't produce it on their own."
    "#1070: While many cats enjoy milk, it will give some cats diarrhea."
    "#1071: A cat will spend nearly 30% of her life grooming herself."
    "#1072: When a domestic cat goes after mice, about 1 pounce in 3 results in a catch."
    "#1073: Mature cats with no health problems are in deep sleep 15 percent of their lives. They are in light sleep 50 percent of the time. That leaves just 35 percent awake time, or roughly 6-8 hours a day."
    "#1074: Cats come back to full alertness from the sleep state faster than any other creature."
    "#1075: A cat can jump 5 times as high as it is tall."
    "#1076: Cats can jump up to 7 times their tail length."
    "#1077: Spaying a female before her first or second heat will greatly reduce the threat of mammary cancer and uterine disease. A cat does not need to have at least 1 litter to be healthy, nor will they \"miss\" motherhood. A tabby named \"Dusty\" gave birth to 420 documented kittens in her lifetime, while \"Kitty\" gave birth to 2 kittens at the age of 30, having given birth to a documented 218 kittens in her lifetime."
    "#1078: Neutering a male cat will, in almost all cases, stop him from spraying (territorial marking), fighting with other males (at least over females), as well as lengthen his life and improve its quality."
    "#1079: Declawing a cat is the same as cutting a human's fingers off at the knuckle. There are several alternatives to a complete declawing, including trimming or a less radical (though more involved) surgery to remove the claws. Instead, train your cat to use a scratching post."
    "#1080: The average lifespan of an outdoor-only (feral and non-feral) is about 3 years; an indoor-only cat can live 16 years and longer. Some cats have been documented to have a longevity of 34 years."
    "#1081: Cats with long, lean bodies are more likely to be outgoing, and more protective and vocal than those with a stocky build."
    "#1082: A steady diet of dog food may cause blindness in your cat - it lacks taurine."
    "#1083: An estimated 50% of today's cat owners never take their cats to a veterinarian for health care. Too, because cats tend to keep their problems to themselves, many owners think their cat is perfectly healthy when actually they may be suffering from a life-threatening disease. Therefore, cats, on an average, are much sicker than dogs by the time they are brought to your veterinarian for treatment."
    "#1084: Never give your cat aspirin unless specifically prescribed by your veterinarian; it can be fatal. Never ever give Tylenol to a cat.  And be sure to keep anti-freeze away from all animals - it's sweet and enticing, but deadly poison.  Related pages:  Substances that are Toxic to Cats; Plants that are Toxic to Cats; First Aid Kit for your Cat; First Aid for Plant Poisoning"
    "#1085: Most cats adore sardines."
    "#1086: A cat uses its whiskers for measuring distances.  The whiskers of a cat are capable of registering very small changes in air pressure."
    "#1087: Cats and People"
    "#1088: It has been scientifically proven that striking a cat can lower one's blood pressure."
    "#1089: In 1987, cats overtook dogs as the number one pet in America (about 50 million cats resided in 24 million homes in 1986). About 37% of American homes today have at least one cat."
    "#1090: If your cat snores or rolls over on his back to expose his belly, it means he trusts you."
    "#1091: Cats respond better to women than to men, probably due to the fact that women's voices have a higher pitch."
    "#1092: In an average year, cat owners in the United States spend over $2 billion on cat food."
    "#1093: According to a Gallup poll, most American pet owners obtain their cats by adopting strays."
    "#1094: When your cats rubs up against you, she is actually marking you as \"hers\" with her scent. If your cat pushes his face against your head, it is a sign of acceptance and affection."
    "#1095: Contrary to popular belief, people are not allergic to cat fur, dander, saliva, or urine - they are allergic to \"sebum,\" a fatty substance secreted by the cat's sebaceous glands. More interesting, someone who is allergic to one cat may not be allergic to another cat. Though there isn't (yet) a way of predicting which cat is more likely to cause allergic reactions, it has been proven that male cats shed much greater amounts of allergen than females. A neutered male, however, sheds much less than a non-neutered male."
    "#1096: Cat bites are more likely to become infected than dog bites."
    "#1097: In just 7 years, one un-spayed female cat and one un-neutered male cat and their offspring can result in 420,000 kittens."
    "#1098: Some notable people who disliked cats:  Napoleon Bonaparte, Dwight D. Eisenhower, Hitler."
    "#1100: Six-toed kittens are so common in Boston and surrounding areas of Massachusetts that experts consider it an established mutation."
    "#1101: The silks created by weavers in Baghdad were inspired by the beautiful and varied colors and markings of cat coats. These fabrics were called \"tabby\" by European traders."
    "#1102: Cat families usually play best in even numbers. Cats and kittens should be acquired in pairs whenever possible."
    "#1103: Cats lived with soldiers in trenches, where they killed mice during World War I."
    "#1104: A male cat is called a \"tom\" (or a \"gib,\" if neutered), and a female is called a \"molly\" or \"queen.\" The father of a cat is its \"sire,\" and mother is its \"dam.\" An immature cat of either sex is called a \"kitten.\" A group of cats is a \"clowder.\""
    "#1105: Cat litter was \"invented\" in 1947 when Edward Lowe asked his neighbor to try a dried, granulated clay used to sop up grease spills in factories. (In 1990, Mr. Lowe sold his business for $200 million.)  Related page:  Other Things You Can Do with Kitty Litter"
    "#1106: The cat appears to be the only domestic companion animal not mentioned in the Bible. *"
    "#1107: The cat does not exist in the Chinese Zodiac, but it does in the Vietnamese version, instead of rabbit. See Folklore, Superstitions, and Proverbs."
    "#666: Cats are dumb."
    "#420: 20% of cats can't get high off of catnip."
  ]

  images: [
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr05/15/9/anigif_enhanced-buzz-26390-1381844163-18.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr06/15/10/anigif_enhanced-buzz-1376-1381846217-0.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr03/15/9/anigif_enhanced-buzz-3391-1381844336-26.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr03/2013/3/19/0/anigif_enhanced-buzz-22150-1363666305-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr03/2013/3/19/0/anigif_enhanced-buzz-24173-1363666504-0.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr03/15/9/anigif_enhanced-buzz-3409-1381844582-13.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr03/2013/3/19/0/anigif_enhanced-buzz-24825-1363666241-0.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr02/15/9/anigif_enhanced-buzz-19667-1381844937-10.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr06/15/10/anigif_enhanced-buzz-23501-1381846064-1.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr01/15/10/anigif_enhanced-buzz-27208-1381845845-0.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr05/15/9/anigif_enhanced-buzz-26358-1381845043-13.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr06/15/10/anigif_enhanced-buzz-25498-1381845743-9.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr02/15/10/anigif_enhanced-buzz-19659-1381845602-0.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr05/15/9/anigif_enhanced-buzz-26383-1381845104-25.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr06/15/9/anigif_enhanced-buzz-23859-1381845509-0.gif"
    "http://s3-ec.buzzfed.com/static/2013-10/enhanced/webdr03/15/10/anigif_enhanced-buzz-11864-1381846346-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr03/2013/3/19/0/anigif_enhanced-buzz-23837-1363666685-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/3/19/0/anigif_enhanced-buzz-16896-1363667138-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr03/2013/3/19/0/anigif_enhanced-buzz-24870-1363667367-2.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/3/19/0/anigif_enhanced-buzz-14734-1363667426-2.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/3/19/0/anigif_enhanced-buzz-14805-1363667480-3.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/3/19/0/anigif_enhanced-buzz-16081-1363667567-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/3/19/0/anigif_enhanced-buzz-16908-1363667752-9.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/3/19/0/anigif_enhanced-buzz-17284-1363667817-6.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr01/2013/3/19/0/anigif_enhanced-buzz-12749-1363667875-7.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr01/2013/3/19/0/anigif_enhanced-buzz-9945-1363668275-2.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr02/2013/3/19/0/anigif_enhanced-buzz-16922-1363667930-1.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr01/2013/3/19/0/anigif_enhanced-buzz-13800-1363668317-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr01/2013/3/19/0/anigif_enhanced-buzz-15526-1363668439-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr01/2013/9/13/11/anigif_enhanced-buzz-5448-1379086972-8.gif"
    "https://raw.github.com/jglovier/gifs/gh-pages/cats/falling-cat-breaks-windwo.gif"
    "http://oi48.tinypic.com/am8te.jpg"
    "https://raw.github.com/jglovier/gifs/gh-pages/cats/cat-fail.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr03/2013/3/19/0/anigif_enhanced-buzz-22993-1363666578-0.gif"
    "http://s3-ec.buzzfed.com/static/enhanced/webdr01/2013/3/19/0/anigif_enhanced-buzz-9933-1363668005-0.gif"
  ]

  fact: ->
    if Math.floor(Math.random() * 10) + 1 < 25
      res = @t('fact', response: @random())
    else
      res = @random(@images)
    speak: res



module.exports  = new Responder()