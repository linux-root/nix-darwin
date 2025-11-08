return {
  "EggbertFluffle/beepboop.nvim",
  enabled = false,
  opts = {
    audio_player = "afplay",
    max_sounds = 100,
    sound_map = {
      { key_map = { mode = "n", key_chord = "<leader>pv" }, sound = "chestopen.mp3" },
      { key_map = { mode = "n", key_chord = "<C-Enter>" }, sound = "chestopen.mp3" },
      { auto_command = "VimEnter", sound = "chestopen.mp3" },
      { auto_command = "VimLeave", sound = "chestclosed.mp3" },
      { auto_command = "InsertCharPre", sounds = { "stone1.mp3", "stone2.mp3", "stone3.mp3", "stone4.mp3" } },
      { auto_command = "TextYankPost", sounds = { "hit1.mp3", "hit2.mp3", "hit3.mp3" } },
      { auto_command = "BufWrite", sounds = { "open_flip1.mp3", "open_flip2.mp3", "open_flip3.mp3" } },
    },
  },
}
