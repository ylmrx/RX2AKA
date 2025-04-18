---@diagnostic disable: lowercase-global, need-check-nil

function s1000_get_basenote_from_sample(filename)
  -- extract the base note from the supplied .s format sample
  -- used for s1000 .p program loading
  local d = "" -- in memory copy
  lsb_first = true

  local f_in = io.open(filename, "rb")
  if f_in == nil then
    print("s1000_get_basenote_from_sample: couldn't open .s sample", filename)
    return nil
  end
  f_in:seek("set")
  d = f_in:read("*a")
  f_in:close()

  if read_byte_from_memory(d, 1) ~= 3 then
    print("s1000_get_basenote_from_sample: not an akai s1000 .s sample")
    d = ""
    return nil
  elseif read_byte_from_memory(d, 16) ~= 128 then
    print("s1000_get_basenote_from_sample: not an akai s1000 .s sample")
    d = ""
    return nil
  end

  local base_note = read_byte_from_memory(d, 3)
  print("s1000_get_basenote_from_sample: base_note", base_note)
  d =""
  return base_note
end

function s1000_loadsample(filename)
  local d = ""
  local aiff_file
  local loop_start = 0
  local loop_end = 0
  local sample_name = ""
  local sample_rate = 0
  local fine_tune = 0
  local transpose = 0
  local active_loop_count = 0
  local t -- temp

  -- Set endianness
  local lsb_first = true

  renoise.app():show_status("Importing Akai S1000/S3000 Sample...")
  local song = renoise.song()
  if not #song.selected_instrument.samples == 0 then
    local s = song.selected_instrument:sample(1)
    for _, slice in pairs(s.slice_markers) do
      s:delete_slice_marker(slice)
    end
  end
  song.selected_instrument:clear()
  song.selected_instrument:insert_sample_at(1)
  if filename:match("-[Ll].[sS]%d*$") then
    print("hello LEFTY")
  end
  -- if the file name has a suffix (-L, -R), import its twin too
  -- pan accordingly... so you get a stereo instrument
  local smp = renoise.song().selected_sample
  -- local s_filename_clean = filename:match("[^/\\]+$") or "Akai Sample"
  -- local instrument_name = s_filename_clean:gsub("%.s$", "")
  local s_basename = filename:match("([^/\\]+)$") or "Akai Sample"
  renoise.song().selected_instrument.name = s_basename
  renoise.song().selected_sample.name = s_basename

  local f_in = io.open(filename, "rb")
  if f_in == nil then
    renoise.app():show_status("Couldn't open sample file: " .. filename .. ".")
    return false
  end
  f_in:seek("set")
  d = f_in:read("*a")
  f_in:close()
  if read_byte_from_memory(d, 1) ~= 3 then
    print("s1000_loadsample: invalid file (byte1)")
    d = ""
    return false
  elseif read_byte_from_memory(d, 16) ~= 128 then
    print("s1000_loadsample: invalid file (byte16)")
    d = ""
    return false
  end
  sample_name = akaii_to_ascii(d:sub(4,15))
  sample_rate = read_word_from_memory(d, 139, lsb_first)
  fine_tune = byte_to_twos_compliment(read_byte_from_memory(d, 21))
  transpose = byte_to_twos_compliment(read_byte_from_memory(d, 22))
  active_loop_count = read_byte_from_memory(d, 17)

  print("s1000 loaded sample:", filename)
  print("s1000_loadsample: sample_name", sample_name)
  print("s1000_loadsample: sample_rate", sample_rate)
  print("s1000_loadsample: fine_tune", fine_tune)
  print("s1000_loadsample: transpose", transpose)
  print("s1000_loadsample: active_loop_count", active_loop_count)

  aiff_file = generate_aiff(1, sample_rate, 16, d:sub(150))
  if smp.sample_buffer.has_sample_data == true then
    if smp.sample_buffer.read_only == true then
      d = ""
      return false
    end
  end
  smp:clear()
---@diagnostic disable-next-line: param-type-mismatch
  if smp.sample_buffer:load_from(aiff_file) == false then
    d = ""
    return false
  end

  smp.fine_tune = fine_tune
  smp.transpose = transpose
  smp.name = sample_name

  -- set looping
  if active_loop_count ~= 0 then
    -- use loop 1
    loop_start = read_dword_from_memory(d, 39, lsb_first)
    loop_end = loop_start + read_dword_from_memory(d, 45, lsb_first)
    -- validate
    if loop_start < 0 then
      loop_start = 0
    elseif loop_start > renoise.song().selected_sample.sample_buffer.number_of_frames then
      loop_start = renoise.song().selected_sample.sample_buffer.number_of_frames
    end
    if loop_end < 0 then
      loop_end = 0
    elseif loop_end > renoise.song().selected_sample.sample_buffer.number_of_frames then
      loop_end = renoise.song().selected_sample.sample_buffer.number_of_frames
    end

    print("s1000_loadsample: loop_start", loop_start)
    print("s1000_loadsample: loop_end", loop_end)
    -- loop location are often faulty... set to no loop to let user decide
    -- smp.loop_mode = renoise.Sample.LOOP_MODE_FORWARD
    smp.loop_start = loop_start
    smp.loop_end = loop_end
  end
  d = ""
  return true
end