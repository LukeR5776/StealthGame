/// @function get_campaign_levels()
function get_campaign_levels() {
    return [
        {
            level_num: 1,
            filename: "campaign_level_1",
            title: "Grandma's House",
            description: "Your grandma's house. She was dumb enough to give you the key. Watch out for the Ring camera.",
            objectives: "• Rob her blind and escape"
        },
        {
            level_num: 2,
            filename: "campaign_level_2",
            title: "The Big Leagues",
            description: "Your first real heist. Lockpick the safe doors. Take out that guard if you can.",
            objectives: "• Collect all money\n• Avoid guards and cameras\n• Reach extraction"
        },
        {
            level_num: 3,
            filename: "campaign_level_3",
            title: "Jailbreak",
            description: "They caught you, you're stuck in the PD for the night. No worries, you snuck your lockpick in. Bust out and take their money with you. ",
            objectives: "• Collect all money\n• Bypass guards and security \n• Reach extraction"
        }
    ];
}

/// @function get_campaign_level_by_num(level_num)
function get_campaign_level_by_num(level_num) {
    var levels = get_campaign_levels();

    for (var i = 0; i < array_length(levels); i++) {
        if (levels[i].level_num == level_num) {
            return levels[i];
        }
    }

    return undefined;
}

/// @function get_campaign_level_count()
function get_campaign_level_count() {
    return array_length(get_campaign_levels());
}
