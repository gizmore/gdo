#
# Traverse the filesystem with a nice helper function.
#
# @see https://github.com/gizmore/filewalker
#
# @version 1.00
# @since 1.00
# @author gizmore@wechall.net
# @license MIT
#
class GDO::File::Walker

  def self.proc_files(dir, pattern='*', dotfiles=true, &block)
    __traverse(dir, pattern, false, dotfiles, true, false, &block)
  end

  def self.traverse_files(dir, pattern='*', dotfiles=true, &block)
    __traverse(dir, pattern, true, dotfiles, true, false, &block)
  end
  
  def self.proc_dirs(dir, pattern='*', dotfiles=true, &block)
    __traverse(dir, pattern, false, dotfiles, false, true, &block)
  end

  def self.traverse_dirs(dir, pattern='*', dotfiles=true, &block)
    __traverse(dir, pattern, true, dotfiles, false, true, &block)
  end
  
  def self.proc_all(dir, pattern='*', dotfiles=true, &block)
    __traverse(dir, pattern, false, dotfiles, true, true, &block)
  end
 
  def self.traverse_all(dir, pattern='*', dotfiles=true, &block)
    __traverse(dir, pattern, true, dotfiles, true, true, &block)
  end

  private
  
  def self.__traverse(dir, pattern='*', recursive=true, dotfiles=true, files=true, dirs=false, &block)
    
    dir = File.dirname(dir) if File.file?(dir)
    
    dir = dir.rtrim('/') + '/'
    
    # Sanity
    raise Exception.new "filewalker(dir) is not a directory: '#{dir}'." unless File.directory?(dir)
    
    # Files first
    if files
      Dir[dir+pattern].each do |path|
        file = path.rsubstr_from('/')
        if (file != '.') && (file != '..')
          if (file[0] != '.') || dotfiles
            if File.file?(path)
              yield(path, nil)
            end
          end
        end
      end
    end
    
    # Dirs
    if recursive || dirs
      Dir[dir+'*'].each do |path|
        file = path.rsubstr_from('/')
        if (file != '.') && (file != '..') # special cases
          if (file[0] != '.') || dotfiles # dotfile optional
            if File.directory?(path)
              if dirs && File.fnmatch(pattern, file)
                yield(nil, path)
              end
              if recursive
                __traverse(path+'/', pattern, recursive, dotfiles, files, dirs, &block)
              end
            end
          end
        end
      end
    end
  end
end
  
