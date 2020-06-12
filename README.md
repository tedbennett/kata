# Language Learning

This app will be an Anki-style language flashcard app. Instead of giving an indication of how well you remember the word on the front of the flashcard (e.g "Fail, Hard, Easy"), you must instead correctly type out the reverse of the card. I find this not only helps to reinforce learning, but for languages with a non-Qwerty keyboard (e.g Korean, Japanese), it helps gain familiarity with the keyboard and builds typing skills.

For first draft, a simple algorithm for words-to-review will be used and decks can be created in-app or imported from a .csv file. Hopefully in the future a more advanced Anki-like algorithm can be implemented as well as using the .apkg format.

## Overview for Historical Data / Review suggestions

This app will be able to give the user a history of their scores in reviews and details as to how well they have learnt each word and deck.

Each review's score will be saved as Historical Data, as a list of each Card ID with it's associated score i.e Right or Wrong. Cards will be unique, meaning that multiple decks can use the same card and its learning-score will be the cumulative result across them all. (i.e if you learn a word in one deck, you wouldn't want to have to relearn it when it appears in another.)

Each card will also have a learning-score associated with it. This is an indicator of the cumulative score of how well a word is learned, i.e 70% correct out of every review. This would be a percentage translated to an enum e.g "Unseen", "Don't Know", "Learned".

Decks will also have a learning-score which is just the average of each card's learning score. A deck's learning score would be used to determine when a deck needs review. E.g < 70% needs daily reviews, <85% needs 3-daily reviews, and <95% needs weekly reviews. Learning scores would perhaps decay over time without review to implement this.

Decks would be grouped by their last review date and their learning score percentage to let the user know which decks need review more urgently.
