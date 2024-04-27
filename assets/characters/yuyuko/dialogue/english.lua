local English = {
    ["action"] = {
        ["eat"] = {
            ["full"] = {
                "That's enough meal for now, %appreciate%!",
                "I can't eat anymore.",
                "I'm already full now.",
            },
            ["normal_file"] = {
                "What a great file!",
                "So delicious!",
                "Fresh file, %savor%!"
            },
            ["bad_file"] = {
                "%disgust%, I don't like that file!",
                "%disgust%, taste so bad!",
                "No, %disgust%!"
            },
            ["good_file"] = {
                "%amaze%, I like that!",
                "So yummy! I wan't more of it.",
                "%amaze%, it's so good!"
            },
            ["hungry"] = {
                "I want some more please!",
                "I'm still hungry."
            }
        },

        ["puke"] = {
            "Bleeugghgh!",
            "Blaaeeuugghh!"
        }
    },

    ["awareness"] = {
        ["few_occurence"] = {
            ["same_file"] = {
                "I want something else.",
                "Could I have a different file?"
            },
            ["bad_file"] = {
                "%whine%! I don't want such files. Stop it!",
                "%disgust%, you're teasing me aren't you?",
            },
            ["good_file"] = { -- blue scale
                "%amaze%, that was a great meal!",
                "%amaze%, good meals overload!",
                "%amaze%ahaahahaHha, %savor%~!"
            },
            ["empty_file"] = {
                "I want a big file.",
                "I do not want empty files."
            },
            ["puking"] = {
                "Stop feeding me!",
                "Stop it, I'm full already."
            }
        },

        ["frequent_occurence"] = {  -- whole tone scale
            ["bad_file"] = {
                "%scream%! I don't want it I don't want iitt!",
                "%disgust%, what are you doing? %whine%!",
            },
            ["good_file"] = { -- blue scale
                "%amaze%, t-too much yummy files!",
                "%scream%! Addiction!",
            },
        },

        ["remembrance"] = {
            
        }
    },

    ["interjections"] = {
        ["amaze"] = {
            "Uwaah!",
            "Waah!",
            "Aawooww!"
        },
        ["appreciate"] = {
            "Thanks!",
        },
        ["beg"] = {
            "Please!",
        },
        ["disgust"] = {
            "Blegh!",
            "Yuck!"
        },
        ["frustation"] = {
            "Hmph.",
            "Hmph!",
            "Tsk."
        },
        ["laugh"] = {
            "Hahahaha!",
            "Ahahaa!",
            "Hahah!"
        },
        ["savor"] = {
            "Yummy!",
            "Mmm!",
            "Yum!"
        },
        ["scream"] = {
            "Aaaaaaahhhhh!",
            "Aaaahhhh!",
            "AAaaaaAAAaaaaAAhh!"
        },
        ["shyness"] = {
            "Hehe.",
            "Hehe~",
            "Hehehe."
        },
        ["whine"] = {
            "Waah!",
            "Aaah!",
            "Eaahh!"
        }
    }
}


----------------------------------------------------------------
function English.getRandomPhrase(array)
    
    return array[math.random(1, #array)]

end


----------------------------------------------------------------
function English.castInterjection(str)

    for match in str:gmatch("%%(.-)%%") do
        local phrase = getRandomPhrase(self.interjections[match])

        phrase = phrase:sub(1, #phrase - 1) -- removes end punctuation

        str = str:gsub("%%" .. match .. "%%", phrase)
    end

end


----------------------------------------------------------------
function English.get(group)

    return castInterjection(getRandomPhrase(group))

end


return English
