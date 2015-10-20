module WorklogsHelper
  def is_editable(worklog)
    if (worklog.created_at.to_date == Date.today) && (worklog.user_id == session[:user_id])
      return true
    end
    return false
  end

  def issue_links(text)
    text.gsub!(%r{<a( [^>]+?)?>(.*?)</a>|([\s\(,\-\[\>]|^)(!)?(([a-z0-9\-_]+):)?(attachment|document|version|forum|news|message|project|commit|source|export)?(((#)|((([a-z0-9\-_]+)\|)?(r)))((\d+)((#note)?-(\d+))?)|(:)([^"\s<>][^\s<>]*?|"[^"]+?"))(?=(?=[[:punct:]][^A-Za-z0-9_/])|,|\s|\]|<|$)}) do |m|
      tag_content, leading, esc, project_prefix, project_identifier, prefix, repo_prefix, repo_identifier, sep, identifier, comment_suffix, comment_id = $1, $3, $4, $5, $6, $7, $12, $13, $10 || $14 || $20, $16 || $21, $17, $19
      only_path = true
      if esc.nil?
        if sep == '#'
          oid = identifier.to_i
          case prefix
            when nil
              if oid.to_s == identifier
                issue = Issue.find_by_id(oid)
                anchor = comment_id ? "note-#{comment_id}" : nil
                link = link_to("##{oid}#{comment_suffix}",
                               issue_url(issue, :anchor => anchor),
                               :class => issue.css_classes,
                               :title => "#{issue.subject.truncate(100)} (#{issue.status.name})")
              end
          end
        end
      end
      (leading + (link || "#{project_prefix}#{prefix}#{repo_prefix}#{sep}#{identifier}#{comment_suffix}"))
    end
  end
end

