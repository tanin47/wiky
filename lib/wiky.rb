module Wiky
  def self.get_attachments(wikitext)
    return [] if wikitext == nil
    return wikitext.scan(/\[\[File:[^\]\n\r ]+\]\]/).map { |img| img[7..-3] }
  end
  
  def self.process(wikitext)
    lines = wikitext.split(/\r?\n/)
    
    html = ""
    
    i = 0
    while i < lines.length
  
      line = lines[i];
      
      if (line.match(/^===/)!=nil and line.match(/===$/)!=nil)
        
        html += "<h2>#{line[3..-4]}</h2>";

      elsif (line.match(/^==/)!=nil and line.match(/==$/)!=nil)

        html += "<h3>#{line[2..-3]}</h3>";

      elsif (line.match(/^:+/)!=nil)

        # find start line and ending line
        start = i;
        while (i < lines.length and lines[i].match(/^\:+/)!=nil) 
          i += 1
        end
        
        i -= 1
        
        html += self.process_indent(lines,start,i);

      elsif (line.match(/^----+(\s*)$/)!=nil)
      
        html += "<hr/>"
      
      elsif (line.match(/^(\*+) /)!=nil)

        # find start line and ending line
        start = i;
        while (i < lines.length && lines[i].match(/^(\*+|\#\#+)\:? /)!=nil) 
          i += 1
        end
        
        i -= 1
        
        html += self.process_bullet_point(lines,start,i);

      elsif (line.match(/^(\#+) /)!=nil)
      
        # find start line and ending line
        start = i;
        while (i < lines.length && lines[i].match(/^(\#+|\*\*+)\:? /)!=nil)
          i += 1
        end
        
        i -= 1
        
        html += self.process_bullet_point(lines,start,i);
      
      else 
      
        html += self.process_normal(line);
      
      end
      
      html += "<br/>\n";
      i += 1
      
    end
    
    return html;
    
  end
  
  private
  def self.process_indent(lines,start_index,end_index)
    i = start_index
  
    html = "<dl>"
    
    while i <= end_index
      
      html += "<dd>"
      
      this_count = lines[i].match(/^(\:+)/)[0].length
      
      html += self.process_normal(lines[i][this_count..-1])
      
      begin
        nested_end = i
        j = i + 1
        while j <= end_index
          nested_count = lines[j].match(/^(\:+)/)[0].length
          if (nested_count <= this_count) 
            break
          else 
            nested_end = j
          end
          j += 1
        end
        
        if (nested_end > i) 
          html += self.process_indent(lines,i+1,nested_end)
          i = nested_end
        end
      end
      
      html += "</dd>"
      i += 1
      
    end
    
    html += "</dl>"
    return html
  end
  
  def self.process_bullet_point(lines,start_index,end_index)
   
    i = start_index
    
    html = (lines[start_index][0].chr=='*')?"<ul>":"<ol>"
    
    
    while i <= end_index
      
      html += "<li>"
      
      this_count = lines[i].match(/^(\*+|\#+) /)[1].length
      
      html += self.process_normal(lines[i][this_count+1..-1])
      
      # continue previous with #:
      begin
        nested_end = i
        j = i + 1
        while j <= end_index
  
          nested_count = lines[j].match(/^(\*+|\#+)\:? /)[1].length
          
          if (nested_count < this_count) 
            
            break;
            
          else
            
            if (lines[j][nested_count].chr == ':') 
              html += "<br/>" + wiky.process_normal(lines[j][nested_count + 2..-1])
              nested_end = j
            else
              break
            end
            
          end
          
          j += 1
        end
        
        i = nested_end
      end
      
      # nested bullet point
      begin
        nested_end = i;
        j = i + 1
        while j <= end_index
        
          nested_count = lines[j].match(/^(\*+|\#+)\:? /)[1].length
          if (nested_count <= this_count) 
            break
          else 
            nested_end = j
          end
          
          j += 1
        end
        
        if (nested_end > i) 
          html += self.process_bullet_point(lines, i + 1, nested_end)
          i = nested_end
        end
      end
      
      # continue previous with #:
      begin
        nested_end = i
        j = i + 1
        while j <= end_index
  
          nested_count = lines[j].match(/^(\*+|\#+)\:? /)[1].length
          
          if (nested_count < this_count) 
            
            break;
            
          else
            
            if (lines[j][nested_count].chr == ':') 
              html += "<br/>" + wiky.process_normal(lines[j][nested_count + 2..-1])
              nested_end = j
            else
              break
            end
            
          end
          
          j += 1
        end
        
        i = nested_end
      end
      
      
      
      html += "</li>";
      i += 1
    end
    
    html += (lines[start_index][0].chr=='*')?"</ul>":"</ol>"
    return html;
  end
  
  def self.process_video(url)
    

    if (url.match(/^(https?:\/\/)?(www.)?youtube.com\//) == nil)
      return "<b>"+url+" is an invalid YouTube URL</b>";
    end
    
    if ((result = url.match(/^(https?:\/\/)?(www.)?youtube.com\/watch\?(.*)v=([^&]+)/)) != nil)
      url = "http://www.youtube.com/embed/"+result[4];
    end
    
    
    return '<iframe width="480" height="390" src="'+url+'" frameborder="0" allowfullscreen></iframe>';

  end
  
  def self.process_image(wikitext)
    index = wikitext.index(" ") || -1
    url = wikitext
    label = ""
    
    if (index > -1) 

      url = wikitext[0..index]
      label = wikitext[index+1..-1]
    
    end
    
    return "<img src='"+url+"' alt=\""+label+"\" />"
  end
  
  def self.process_url(wikitext)
    index = wikitext.index(" ") || -1
    
    if (index == -1) 
    
      return "<a target='"+txt+"' href='"+txt+"' style='background: url(\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAFZJREFUeF59z4EJADEIQ1F36k7u5E7ZKXeUQPACJ3wK7UNokVxVk9kHnQH7bY9hbDyDhNXgjpRLqFlo4M2GgfyJHhjq8V4agfrgPQX3JtJQGbofmCHgA/nAKks+JAjFAAAAAElFTkSuQmCC\") no-repeat scroll right center transparent;padding-right: 13px;'></a>"
    
    else
    
      url = wikitext[0..index]
      label = wikitext[index+1..-1]
      return "<a target='"+url+"' href='"+url+"' style='background: url(\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAFZJREFUeF59z4EJADEIQ1F36k7u5E7ZKXeUQPACJ3wK7UNokVxVk9kHnQH7bY9hbDyDhNXgjpRLqFlo4M2GgfyJHhjq8V4agfrgPQX3JtJQGbofmCHgA/nAKks+JAjFAAAAAElFTkSuQmCC\") no-repeat scroll right center transparent;padding-right: 13px;'>"+label+"</a>"
    
    end
  end
  
  def self.process_normal(wikitext)

    # Image
    index = wikitext.index("[[File:") || -1
    end_index = wikitext.index("]]", index + 7) || -1
    while (index > -1 and end_index > -1) 
    
      new_wikitext = ""
      new_wikitext += wikitext[0..index-1] if index > 0
      new_wikitext += self.process_image(wikitext[index+7..end_index-1])
      new_wikitext += wikitext[end_index+2..-1] if (end_index+2) < (wikitext.length-1)
    
      wikitext = new_wikitext
    
      index = wikitext.index("[[File:",end_index+1) || -1
      end_index = wikitext.index("]]", index + 7) || -1
    end
    
    # Video
    index = wikitext.index("[[Video:") || -1
    end_index = wikitext.index("]]", index + 8) || -1
    while (index > -1 and end_index > -1) 
    
      new_wikitext = ""
      new_wikitext += wikitext[0..index-1] if index > 0
      new_wikitext += self.process_video(wikitext[index+8..end_index-1])
      new_wikitext += wikitext[end_index+2..-1] if (end_index+2) < (wikitext.length-1)
    
      wikitext = new_wikitext
    
      index = wikitext.index("[[Video:",end_index+1) || -1
      end_index = wikitext.index("]]", index + 8) || -1
    end
    
    
    # URL
    ["http","ftp","news"].each { |protocol|
    
      index = wikitext.index("["+protocol+"://") || -1
      end_index = wikitext.index("]", index + 1) || -1
      while (index > -1 and end_index > -1) 
      
        new_wikitext = ""
        new_wikitext += wikitext[0..index-1] if index > 0
        new_wikitext += self.process_url(wikitext[index+1..end_index-1])
        new_wikitext += wikitext[end_index+1..-1] if (end_index+1) < (wikitext.length-1)
      
        wikitext = new_wikitext
      
        index = wikitext.index("["+protocol+"://",end_index+1) || -1
        end_index = wikitext.index("]", index + 1) || -1
        
      end
    }
    
    count_b = 0;
    index = wikitext.index("'''") || -1
    while(index > -1) 
      
      if ((count_b%2)==0) 
        wikitext.sub!(/'''/,"<b>")
      else 
        wikitext.sub!(/'''/,"</b>")
      end
      
      count_b += 1
      
      index = wikitext.index("'''",index) || -1
      
    end
    
    count_i = 0;
    index = wikitext.index("''") || -1
    while(index > -1) 
      
      if ((count_i%2)==0) 
        wikitext.sub!(/''/,"<i>")
      else 
        wikitext.sub!(/''/,"</i>")
      end
      
      count_i += 1
      
      index = wikitext.index("''",index) || -1
    end
    
    wikitext.gsub!(/<\/b><\/i>/,"</i></b>");
    
    return wikitext;
  end
end