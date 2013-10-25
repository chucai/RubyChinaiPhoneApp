module ChaComponent
    def empty_cell
      cell = UITableViewCell.alloc.init
      cell.contentView.subviews.each do |subview|
        subview.removeFromSuperview
      end
      cell
    end

    def blank_cell
        cell = empty_cell
        imageview = UIImageView.alloc.initWithImage(UIImage.imageNamed:'404.jpg')
        imageview.frame        = [[0, 0], [320, 416]]
        cell.contentView.addSubview(imageview)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell
    end

    def loadmore_cell
        cell = empty_cell
        label = UILabel.alloc.initWithFrame([[130, 10], [200, 20]])
        label.text     = '加载更多'
        cell.contentView.addSubview(label)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell
    end

    def loading_cell
        cell = empty_cell
        label = UILabel.alloc.initWithFrame([[130, 10], [200, 20]])
        label.text     = '正在加载'
        cell.contentView.addSubview(label)

        progressInd    = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
        progressInd.center= CGPointMake(110,20)
        cell.contentView.addSubview(progressInd)
        progressInd.startAnimating
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell
    end

    def blank_cell_with_string(str)
        cell = empty_cell

        lbl                 = UILabel.alloc.initWithFrame([[20, 150], [280, 100]])
        lbl.text            = str
        lbl.numberOfLines   = 0
        lbl.backgroundColor = UIColor.clearColor
        lbl.textColor       = UIColor.darkGrayColor
        lbl.font            = UIFont.systemFontOfSize(16)
        lbl.textAlignment   = UITextAlignmentCenter
        #lbl.sizeToFit
        cell.contentView.addSubview(lbl)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell
    end
end
