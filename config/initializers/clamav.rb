if defined? ClamAV
  ClamAV.instance.loaddb
  ClamAV.instance.setlimit(CL_ENGINE_MAX_FILESIZE, 250 * 1024 * 1024)
end
