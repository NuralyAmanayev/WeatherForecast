//
//  HourlyTableViewCell.swift
//  MyWeather
//
//  Created by Nuraly Amanayev on 10/1/21.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "HourlyTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
    func configure(with model: listModel) {
        self.tempLabel.text = "\(String(model.main.celsius))°С"
        self.descriptionLabel.text = "\(model.weather[0].description)"
        self.timeLabel.text = getDayForDate(model.date)
        self.hourLabel.text = getHourForDate(model.date)
        self.iconImageView.contentMode = .scaleAspectFit
        
        let icon = model.weather[0].main.lowercased()
        if icon.contains("clear"){
            self.iconImageView.image = UIImage(named: "clear")
        }
        else if icon.contains("clouds"){
            self.iconImageView.image = UIImage(named: "cloud")
        }
        else if icon.contains("rain"){
            self.iconImageView.image = UIImage(named: "rain")
        }
        else if icon.contains("snow"){
            self.iconImageView.image = UIImage(named: "snow")
        }
        else {
            self.iconImageView.image = UIImage(named: "sunny")
        }
        

    }
    
    func getHourForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: inputDate)
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
    
}
