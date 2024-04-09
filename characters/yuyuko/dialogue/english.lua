local English = {
    ["action"] = {
        ["eat"] = {
            ["full"] = {
                "That's enough meal for now, %appreciate%!",
                "I can't eat anymore.",
                "I'm already full now.",
            },
            ["normal_file"] = {
                "What a great file.",
                "So delicious."
            },
            ["bad_file"] = {
                "%disgust%, I don't like that file!",
                "%disgust%, taste so bad!",
                "No, %disgust%!"
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
        ["less_repetition"] = {
            ["same_file"] = {
                "I want something else.",
                "Could I have a different file?"
            },
            ["bad_file"] = {
                "%whine%! I don't want such files. Stop it!",
                "%disgust%, you're teasing me aren't you?",
            },
            ["empty_file"] = {
                "I want a full file.",
                "I do not want empty files."
            },
            ["puking"] = {
                "Stop feeding me!",
                "Stop it, I'm full already."
            }
        },

        ["frequent_repetition"] = {
            ["bad_file"] = {
                "%scream%! I don't want it I don't want iitt!!",
                "%disgust%, what are you doing? %whine%!",
            },
        },

        ["remembrance"] = {
            
        }
    },

    ["interjections"] = {
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
function English:castInterjection(str)

    for match in str:gmatch("%%(.-)%%") do
        local phrase = self:getRandomPhrase(self.interjections[match])

        phrase = phrase:sub(1, #phrase - 1) -- removes end punctuation

        str = str:gsub("%%" .. match .. "%%", phrase)
    end

end


----------------------------------------------------------------
function English:getRandomPhrase(array)

    return array[math.random(1, #array)]

end


return English
