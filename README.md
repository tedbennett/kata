# Language Learning

## Description

This is a flashcard app to help learn languages, with the emphasis in learning how to type in another language (most helpful for a language with a different keyboard than one you are familiar with). Instead of giving an indication of how well you remember the word on the front of the flashcard (e.g "Fail, Hard, Easy"), you must instead correctly type out the reverse of the card. I personally find this helps reinforce learning, and has the bonus of improving typing skills.

## Future Work
**Near future**
- Stats view - past review scores, daily trends etc.
- "Learned" percentage (see below)
- Firebase/GCloud Machine Translation suggestions when creating cards

**Further down the road**
- Simplify deck creation
- Sounds to assist learning
- Anki .apkg format import
- CloudKit/Firebase integration to sync review history and decks

**Known Issues**
- Finish Review modal 'Done' button sometimes doesn't pop the view
- Finish Review modal animations class with NavigationView animations
- Issue with custom TextField and bindings (particularly keyboard language)
- Adding cards to a deck causes the Last Review percentage to change


## Overview for Historical Data / Review suggestions

This app will be able to give the user a history of their scores in reviews and details as to how well they have learnt each word and deck.

Each review's score will be saved as Historical Data, as a list of each Card ID with it's associated score i.e Right or Wrong. Cards will be unique, meaning that multiple decks can use the same card and its learning-score will be the cumulative result across them all. (i.e if you learn a word in one deck, you wouldn't want to have to relearn it when it appears in another.)

Each card will also have a learning-score associated with it. This is an indicator of the cumulative score of how well a word is learned, i.e 70% correct out of every review. This would be a percentage translated to an enum e.g "Unseen", "Don't Know", "Learned".

Decks will also have a learning-score which is just the average of each card's learning score. A deck's learning score would be used to determine when a deck needs review. E.g < 70% needs daily reviews, <85% needs 3-daily reviews, and <95% needs weekly reviews. Learning scores would perhaps decay over time without review to implement this.

Decks would be grouped by their last review date and their learning score percentage to let the user know which decks need review more urgently.
